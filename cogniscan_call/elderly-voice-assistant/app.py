import random, json, os, google.generativeai as genai
from flask import Flask, request
from twilio.twiml.voice_response import VoiceResponse, Gather

app = Flask(__name__)

# --- CONFIG ---
# Replace with your actual Gemini API Key
genai.configure(api_key="---API KEY---")
gemini = genai.GenerativeModel('gemini-2.5-flash-lite')

WORDS_DATA = {
    'en': ["Apple", "River", "Table", "Garden", "Cloud"],
    'hi': ["सेब", "नदी", "मेज", "बगीचा", "बादल"]
}

ANIMALS = ["tiger", "lion", "elephant", "dog", "cat", "cow"]


def save_to_local(data):
    file = 'cognitive_results.json'
    results = []
    if os.path.exists(file):
        with open(file, 'r') as f:
            results = json.load(f)
    results.append(data)
    with open(file, 'w') as f:
        json.dump(results, f, indent=4)


# ---------------- START CALL ----------------
@app.route("/voice", methods=['GET', 'POST'])
def voice():
    response = VoiceResponse()
    # 2-second pause allows the Twilio trial message to finish playing
    response.pause(length=2)

    gather = Gather(input='speech dtmf', action='/select-lang', timeout=5)
    gather.say("Welcome. Press 1 for English. हिंदी के लिए 2 दबाएं।", voice='Polly.Aditi', language='hi-IN')
    response.append(gather)

    response.redirect('/voice')
    return str(response)


# ---------------- LANGUAGE ----------------
@app.route("/select-lang", methods=['GET', 'POST'])
def select_lang():
    digit = request.values.get('Digits', '')
    speech = request.values.get('SpeechResult', '').lower()

    lang = 'hi' if ('2' in digit or 'hindi' in speech) else 'en'

    selected_words = random.sample(WORDS_DATA[lang], 3)

    # CRITICAL FIX: No spaces for the URL target parameter to prevent 400 errors
    words_url_param = ",".join(selected_words)
    # Natural spaces for the TTS to speak
    words_to_say = ", ".join(selected_words)

    response = VoiceResponse()

    # Passing the target words in the action URL
    action_url = f"/check-memory?lang={lang}&target={words_url_param}"

    gather = Gather(input='speech', action=action_url, timeout=10, speech_timeout='auto')

    if lang == 'hi':
        gather.say(f"इन तीन शब्दों को मेरे बाद दोहराएं: {words_to_say}", voice='Polly.Aditi', language='hi-IN')
    else:
        gather.say(f"Please repeat these three words after me: {words_to_say}", voice='Polly.Aditi', language='en-US')

    response.append(gather)
    return str(response)


# ---------------- MEMORY CHECK ----------------
@app.route("/check-memory", methods=['GET', 'POST'])
def check_memory():
    lang = request.args.get('lang', 'en')
    target = request.args.get('target', '').lower().split(",")
    user_input = request.values.get('SpeechResult', '').lower()

    score = sum(1 for w in target if w.strip() and w.strip() in user_input)

    save_to_local({"game": "memory", "score": score, "total": len(target)})

    response = VoiceResponse()

    # Gemini micro-feedback
    try:
        prompt = f"The user got {score} out of 3 in a memory test. Give a very short, warm 1-sentence encouragement in {lang}."
        feedback = gemini.generate_content(prompt).text.strip()
    except:
        feedback = "Good try! Let's move to the next part."

    response.say(feedback, voice='Polly.Aditi', language='hi-IN' if lang == 'hi' else 'en-US')

    # Transition to Attention
    response.redirect(f"/start-attention?lang={lang}")
    return str(response)


# ---------------- START ATTENTION ----------------
@app.route("/start-attention", methods=['GET', 'POST'])
def start_attention():
    lang = request.args.get('lang', 'en')
    response = VoiceResponse()

    msg = "Level 2: Attention. Say YES only when you hear an animal name."
    if lang == 'hi':
        msg = "लेवल 2: एकाग्रता। जब आप किसी जानवर का नाम सुनें, तो हाँ कहें।"

    response.say(msg, voice='Polly.Aditi', language='hi-IN' if lang == 'hi' else 'en-US')
    response.redirect(f"/attention-step?lang={lang}&score=0&index=0")
    return str(response)


# ---------------- ATTENTION LOOP ----------------
@app.route("/attention-step", methods=['GET', 'POST'])
def attention_step():
    lang = request.args.get('lang')
    score = int(request.args.get('score', 0))
    index = int(request.args.get('index', 0))
    words = ["table", "tiger", "chair", "lion", "phone"]

    if index >= len(words):
        response = VoiceResponse()
        response.redirect(f"/finish?lang={lang}&score={score}")
        return str(response)

    word = words[index]
    response = VoiceResponse()

    # URL-encoding the word for safety
    action_url = f"/process-attention?lang={lang}&score={score}&index={index}&word={word}"

    gather = Gather(input='speech', action=action_url, timeout=3, speech_timeout='1')
    gather.say(word, voice='Polly.Aditi', language='hi-IN' if lang == 'hi' else 'en-US')
    response.append(gather)

    # If they don't say anything, move to the next word automatically
    response.redirect(f"/attention-step?lang={lang}&score={score}&index={index + 1}")
    return str(response)


# ---------------- PROCESS ATTENTION ----------------
@app.route("/process-attention", methods=['GET', 'POST'])
def process_attention():
    lang = request.args.get('lang')
    score = int(request.args.get('score', 0))
    index = int(request.args.get('index', 0))
    word = request.args.get('word', '').lower()
    user_said = request.values.get('SpeechResult', '').lower()

    if word in ANIMALS and ("yes" in user_said or "हाँ" in user_said):
        score += 1

    response = VoiceResponse()
    # Move to next index
    response.redirect(f"/attention-step?lang={lang}&score={score}&index={index + 1}")
    return str(response)


# ---------------- END ----------------
@app.route("/finish", methods=['GET', 'POST'])
def finish():
    lang = request.args.get('lang', 'en')
    score = int(request.args.get('score', 0))

    save_to_local({"game": "attention", "score": score, "total": 2})  # There were 2 animals in the list

    response = VoiceResponse()
    msg = "You did very well today. I have saved your results. Goodbye!"
    if lang == 'hi':
        msg = "आपने आज बहुत अच्छा किया। मैंने आपके परिणाम सहेज लिए हैं। अलविदा!"

    response.say(msg, voice='Polly.Aditi', language='hi-IN' if lang == 'hi' else 'en-US')
    response.hangup()
    return str(response)


if __name__ == "__main__":
    app.run(debug=True, port=5000)
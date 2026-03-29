const assistantDisplay = document.getElementById('assistant-text');
const debugDisplay = document.getElementById('debug-text');
const statusBadge = document.getElementById('status-badge');
const scoreDisplay = document.getElementById('score');
const repeatBtn = document.getElementById('repeat-btn');

let state = {
    step: 'START', // START, LANG_SELECTION, MEMORY, MATH, FINISHED
    lang: 'en',
    score: 0,
    currentChallenge: null,
    isTalking: false
};

const STRINGS = {
    en: {
        greet: "Hello. I am your companion. For English, say 1. For Hindi, say 2.",
        retry: "I didn't catch that. Please say 1 or 2.",
        memIntro: "Great! Let's start with a memory game. Repeat these words: ",
        mathIntro: "Well done. Now, repeat these numbers: ",
        correct: "That is correct!",
        wrong: "Not quite, but good try.",
        final: "The session is complete. Your final score is "
    },
    hi: {
        greet: "नमस्ते। मैं आपका साथी हूँ। अंग्रेजी के लिए 1, हिंदी के लिए 2 कहें।",
        retry: "क्षमा करें, मुझे समझ नहीं आया। 1 या 2 कहें।",
        memIntro: "बहुत अच्छा। चलिए याददाश्त के खेल से शुरू करते हैं। इन शब्दों को दोहराएं: ",
        mathIntro: "बहुत बढ़िया। अब इन नंबरों को दोहराएं: ",
        correct: "बिल्कुल सही जवाब!",
        wrong: "कोई बात नहीं, अच्छा प्रयास था।",
        final: "खेल समाप्त। आपका स्कोर है "
    }
};

const synth = window.speechSynthesis;
const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
const recognition = new SpeechRecognition();
recognition.continuous = false;
recognition.interimResults = false;

function speak(text) {
    state.isTalking = true;
    synth.cancel();
    const msg = new SpeechSynthesisUtterance(text);
    msg.lang = state.lang === 'hi' ? 'hi-IN' : 'en-US';
    msg.rate = 0.8; // Slow for elderly users

    msg.onstart = () => {
        statusBadge.textContent = "⏳ TALKING";
        statusBadge.className = "speaking";
        assistantDisplay.textContent = text;
    };

    msg.onend = () => {
        state.isTalking = false;
        statusBadge.textContent = "👂 LISTENING";
        statusBadge.className = "listening";
        try { recognition.start(); } catch(e) { console.log("Mic already active"); }
    };
    synth.speak(msg);
}

recognition.onresult = (event) => {
    const heard = event.results[0][0].transcript.toLowerCase();
    debugDisplay.textContent = `Heard: "${heard}"`;
    handleLogic(heard);
};

// If the mic stops without hearing anything, we allow the Repeat button to reset it
recognition.onend = () => {
    if (!state.isTalking) {
        statusBadge.textContent = "⏳ STANDBY";
        statusBadge.className = "idle";
    }
};

function handleLogic(input) {
    // 1. Language Selection
    if (state.step === 'LANG_SELECTION' || state.step === 'START') {
        if (input.includes('1') || input.includes('one') || input.includes('english')) {
            state.lang = 'en';
            startMemoryGame();
        } else if (input.includes('2') || input.includes('two') || input.includes('hindi')) {
            state.lang = 'hi';
            startMemoryGame();
        } else {
            speak(STRINGS.en.retry);
        }
    }
    // 2. Memory Game Validation
    else if (state.step === 'MEMORY') {
        const isCorrect = state.currentChallenge.every(word => input.includes(word.toLowerCase()));
        if (isCorrect) state.score++;
        const feedback = isCorrect ? STRINGS[state.lang].correct : STRINGS[state.lang].wrong;
        startMathGame(feedback);
    }
    // 3. Math Game Validation
    else if (state.step === 'MATH') {
        const isCorrect = input.includes(state.currentChallenge.replace(/\s/g, ''));
        if (isCorrect) state.score++;
        state.step = 'FINISHED';
        scoreDisplay.textContent = state.score;
        speak(STRINGS[state.lang].final + state.score);
    }
}

function startMemoryGame() {
    state.step = 'MEMORY';
    state.currentChallenge = state.lang === 'en' ? ["Apple", "River", "Table"] : ["सेब", "नदी", "मेज"];
    speak(STRINGS[state.lang].memIntro + state.currentChallenge.join(", "));
}

function startMathGame(feedback) {
    state.step = 'MATH';
    state.currentChallenge = "7 3";
    speak(feedback + " " + STRINGS[state.lang].mathIntro + state.currentChallenge);
}

// Interaction to unlock Audio
document.body.onclick = () => {
    if (state.step === 'START') {
        state.step = 'LANG_SELECTION';
        speak(STRINGS.en.greet);
    }
};

repeatBtn.onclick = (e) => {
    e.stopPropagation(); // Prevent triggerring the body click
    speak(assistantDisplay.textContent);
};
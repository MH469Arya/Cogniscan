# from twilio.rest import Client
#
# # Twilio Credentials
# account_sid = 'ACaad6212f586a4cd6393310a6918e3aac'
# auth_token = 'f9f0f170df701a2dff86b94bfc4eef50'
# client = Client(account_sid, auth_token)
#
# # Static Ngrok URL from your dashboard
# NGROK_URL = 'https://ross-unexploitative-unhinderably.ngrok-free.dev'
#
# try:
#     call = client.calls.create(
#         to='+918451033512',
#         from_='+14788003151',
#         url=f'{NGROK_URL}/voice'
#     )
#     print(f"🚀 Call triggered! SID: {call.sid}")
# except Exception as e:
#     print(f"❌ Error: {e}")
from twilio.rest import Client

account_sid = '---SECRET KEY---'
auth_token = '---SECRET KEY---'

client = Client(account_sid, auth_token)

NGROK_URL = 'https://ross-unexploitative-unhinderably.ngrok-free.dev'

call = client.calls.create(
    to='PhoneNumber',  # Replace with the actual phone number you want to call
    from_='PhoneNumber',  # Replace with your Twilio phone number
    url=f'{NGROK_URL}/voice'
)

print("Call triggered:", call.sid)
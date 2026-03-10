import os
from openai import OpenAI

key = os.environ.get('KIMI_API_KEY')
client = OpenAI(api_key=key, base_url='https://api.moonshot.cn/v1')

try:
    response = client.chat.completions.create(
        model='kimi-k2.5',
        messages=[{'role': 'user', 'content': 'Hi'}],
        max_tokens=5
    )
    print('OK')
except Exception as e:
    print(f'FAIL: {e}')

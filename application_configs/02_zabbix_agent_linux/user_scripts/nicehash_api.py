import hashlib
import hmac
import json
import logging
import os
import time
import uuid
import requests


class NicehashAPI:
    def __init__(self):
        self.url = "https://api2.nicehash.com/main/api/v2/mining/rigs2"
        self.api_key = os.environ['NICEHASH_API_KEY']
        self.api_secret_key = os.environ['NICEHASH_API_SECRET_KEY']
        self.x_time = self.get_timestamp_ms()
        self.x_nonce = self.get_random_uuid()
        self.x_organization_id = os.environ['NICEHASH_ORGANIZATION_ID']
        self.request_method = 'GET'
        self.request_path = '/main/api/v2/mining/rigs2'
        self.request_query_string = ''
        self.request_body = ''
        self.empty_field = '\0'
        self.x_user_agent = 'Mozilla/5.0 (Windows; U; Windows NT 5.2) ' \
                            'AppleWebKit/532.1.0 (KHTML, like Gecko) ' \
                            'Chrome/27.0.861.0 Safari/532.1.0'

        self.x_auth = f'{self.api_key}:{self.get_hmac_signature()}'
        self.x_request_id = self.get_random_uuid()

    @staticmethod
    def get_random_uuid() -> str:
        return str(uuid.uuid4())

    @staticmethod
    def get_timestamp_ms() -> str:
        return str(int(time.time() * 1000))

    def get_hmac_signature(self) -> str:
        hmac_signature = hmac.new(bytes(self.api_secret_key, 'utf-8'),
                                  bytes(self.get_hmac_input_str(), 'utf-8'),
                                  hashlib.sha256).hexdigest()
        return hmac_signature

    def get_hmac_input_str(self) -> str:
        hmac_input_str = f'{self.api_key}{self.empty_field}' \
                         f'{self.x_time}{self.empty_field}' \
                         f'{self.x_nonce}{self.empty_field}{self.empty_field}' \
                         f'{self.x_organization_id}{self.empty_field}{self.empty_field}' \
                         f'{self.request_method}{self.empty_field}' \
                         f'{self.request_path}{self.empty_field}' \
                         f'{self.request_query_string}'
        return hmac_input_str

    def get_headers(self) -> dict:
        headers = {
            'X-Time': self.x_time,
            'X-Nonce': self.x_nonce,
            'X-Organization-Id': self.x_organization_id,
            'X-Auth': self.x_auth,
            'X-Request-Id': self.x_request_id,
            'X-User-Agent': self.x_user_agent,
            'X-User-Lang': 'en'
        }
        return headers


def main():
    nicehash_api = NicehashAPI()
    response = requests.request("GET", nicehash_api.url, headers=nicehash_api.get_headers())
    print(json.dumps(response.json(), indent=4))


if __name__ == '__main__':
    logger = logging.getLogger(__name__)

    try:
        main()
    except Exception as e:
        logger.exception(e)

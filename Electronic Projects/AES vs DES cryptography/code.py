from hashlib import sha256
import base64
from Crypto import Random
from Crypto.Random import *
from Crypto.Cipher import AES

blockSize = 16
pad = lambda s: bytes(s + (blockSize - len(s) % blockSize) * chr(blockSize - len(s) % blockSize), 'utf-8')
unpad = lambda s : s[0:-ord(s[-1:])]

class AESCipher:
    key_location = ""
    #key = ""
    def __init__( self, key, key_location):
        #self.key = key
        self.key = bytes(key, 'utf_8')
        self.key_location = key_location           
        

    def encrypt( self, raw ):
        raw = pad(raw)
        iv = Random.new().read( AES.block_size )
        cipher = AES.new(self.key, AES.MODE_CBC, iv )
        file_out = open(self.key_location, "wb") # wb = write bytes
        file_out.write(self.key)
        file_out.close()
        return base64.b64encode( iv + cipher.encrypt( raw ) )

    def decrypt( self, enc ):
        enc = base64.b64decode(enc)
        iv = enc[:16]
        file_in = open(self.key_location, "rb") 
        key_from_file = file_in.read()
        file_in.close()
        cipher = AES.new(key_from_file, AES.MODE_CBC, iv )
        return unpad(cipher.decrypt( enc[16:] )).decode('utf8')


cipher = AESCipher('mysecretpasswordmysecretpassword','G:\Projects\SEM 7\ITC\key.txt') #get_random_bytes(16)
encrypted = cipher.encrypt('Maniac')
#print(pad("ITC"))
decrypted = cipher.decrypt(encrypted)

print(encrypted)
print(decrypted)
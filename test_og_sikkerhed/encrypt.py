
def encrypt(input, digit):
    newString=''
    cleanInput =''
    cleanInput = ''.join(c for c in input if c.isalpha())
    print(cleanInput)
    for i in cleanInput:
        newDigit = ord(i) + int(digit)
        newString = newString + chr(newDigit)
    print(newString)
    return newString

def decrypt(input, digit):
    newString=''
    for i in input:
        newDigit = ord(i) - int(digit)
        newString = newString + chr(newDigit)
    print(newString)
    return newString

def start_encrypt():
    inputString = input('Input string to encrypt: ')
    digit = input('Input encryption digit: ')
    encrypt(inputString, digit)

def start_decrypt():
    inputString = input('Input string to decrypt: ')
    digit = input('Input decryption digit: ')
    decrypt(inputString, digit)

if __name__ == "__main__":
    start_encrypt()
    start_decrypt()
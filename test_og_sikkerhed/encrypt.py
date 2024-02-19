import string

string.ascii_uppercase

def encrypt(input, digit):
    newString=''
    cleanInput = clean_string(input)
    for i in cleanInput:
        if i == ' ':
            newString+= ' '
            continue
        newDigit = ord(i) + int(digit)
        newString = newString + chr(newDigit) if chr(newDigit).isalpha() else newString + get_letter_index(i, digit)
    print(newString)
    return newString

def get_letter_index(letter, digit):
    num = ord(letter) + int(digit)
    num2 = num - 26
    return chr(num2)

def decrypt(input, digit):
    newString=''
    cleanInput = clean_string(input)
    for i in cleanInput:
        if i == ' ':
            newString+= ' '
            continue
        newDigit = ord(i) - int(digit)
        newString = newString + chr(newDigit) if chr(newDigit).isalpha() else newString + get_letter_index(i, digit)
    print(newString)
    return newString

def clean_string(string):
    cleanInput =''
    cleanInput = ''.join(c for c in string if c.isalpha() or c == ' ')
    return cleanInput

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




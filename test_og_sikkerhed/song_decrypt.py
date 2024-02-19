import re
from collections import Counter

# English letter frequency
freq_norm = {'a':0.64297,'b':0.11746,'c':0.21902, 'd':0.33483, 'e':1.00000, 'f':0.17541,
                        'g':0.15864, 'h':0.47977, 'i':0.54842, 'j':0.01205, 'k':0.06078, 'l':0.31688, 'm':0.18942,
                        'n':0.53133, 'o':0.59101, 'p':0.15187, 'q':0.00748, 'r':0.47134, 's':0.49811, 't':0.71296,
                        'u':0.21713, 'v':0.07700, 'w':0.18580, 'x':0.01181, 'y':0.15541, 'z':0.00583}

def caesar_decrypt(ciphertext, shift):
    decrypted_text = ''
    for char in ciphertext:
        if char.isalpha():
            shifted_char = chr(((ord(char.lower()) - ord('a') - shift) % 26) + ord('a'))
            if char.isupper():
                shifted_char = shifted_char.upper()
            decrypted_text += shifted_char
        else:
            decrypted_text += char
    return decrypted_text

def score_text(text):
    text = re.sub(r'[^a-zA-Z]', '', text.lower())
    text_length = len(text)
    letter_counts = Counter(text)
    score = 0
    for letter, frequency in freq_norm.items():
        expected_count = frequency * text_length
        actual_count = letter_counts.get(letter, 0)
        score += (actual_count - expected_count) ** 2 / expected_count
    return score

def decrypt_with_best_guess(ciphertext):
    best_score = float('inf')
    best_guess = ''
    for shift in range(26):
        decrypted_text = caesar_decrypt(ciphertext, shift)
        print(shift)
        print(decrypted_text)
        score = score_text(decrypted_text)
        if score < best_score:
            best_score = score
            best_guess = decrypted_text
    return best_guess

# Example usage:
song = input('Input encrypted song text: ')
decrypted_message = decrypt_with_best_guess(song)
print("Decrypted message:", decrypted_message)
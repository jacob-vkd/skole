from encrypt import encrypt, decrypt

def test_encrypt():
    assert encrypt('Aab vinder guld igen', 7) == 'Hhi vpukly nusk pnlu', "Should be True"
    assert encrypt('Programmering er sjovt', 16) == 'jgl', "Should be True"
    assert encrypt('H5PD rejser sig, i det Per Kommer ind i lokalet', 4) == 'jgl', "Should be True"

def test_decrypt():
    assert decrypt('jgl', 2) == 'hej', "Should be True"

if __name__ == "__main__":
    test_encrypt()
    test_decrypt()
    print("Everything passed")
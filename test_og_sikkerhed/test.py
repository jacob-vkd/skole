from encrypt import encrypt, decrypt

def test_encrypt():
    assert encrypt('hej', 2) == 'jgl', "Should be True"

def test_decrypt():
    assert decrypt('jgl', 2) == 'hej', "Should be True"

if __name__ == "__main__":
    test_encrypt()
    test_decrypt()
    print("Everything passed")
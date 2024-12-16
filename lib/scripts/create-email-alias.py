import random
import string

def generate_alias(length: int, chars_to_use: list[str]) -> str:
  password = ""
  for _ in range(length):
      password += random.choice(random.choice(chars_to_use))

  return password


def main():
  alias = generate_alias(20, [string.ascii_letters + string.digits])

  print(f"Alias: {alias}@uwuwhatsthis.de")

if __name__ == '__main__':
  main()

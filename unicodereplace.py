#!/usr/bin/env python3
import sys
import os

def get_unicode_chars(text):
    return sorted(set(c for c in text if ord(c) > 127))

def unicode_codepoint(char):
    return f"U+{ord(char):04X}"

def prompt_replacements(chars):
    replacements = {}
    for char in chars:
        cp = unicode_codepoint(char)
        print(f"Found character: '{char}' ({cp})")
        choice = input("Replace it? [y/N]: ").strip().lower()
        if choice == 'y':
            while True:
                repl = input(f"Replace '{char}' with (leave blank to skip): ")
                if repl == '':
                    print("Skipped.\n")
                    break
                confirm = input(f"Confirm replacement: '{char}' → '{repl}' [y/N]: ").strip().lower()
                if confirm == 'y':
                    replacements[char] = repl
                    break
        else:
            print("Skipped.\n")
    return replacements

def apply_replacements(text, replacements):
    for char, repl in replacements.items():
        text = text.replace(char, repl)
    return text

def process_file(filepath, replacements):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    new_content = apply_replacements(content, replacements)

    if new_content != content:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(new_content)
        print(f"Updated: {filepath}")
    else:
        print(f"No changes needed: {filepath}")

def main():
    if len(sys.argv) < 2:
        print("Usage: python unicode_replace.py file1 [file2 ...]")
        sys.exit(1)

    all_chars = set()
    files = sys.argv[1:]
    contents = {}

    for filepath in files:
        if not os.path.isfile(filepath):
            print(f"File not found: {filepath}")
            continue
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
            contents[filepath] = content
            all_chars.update(get_unicode_chars(content))

    if not all_chars:
        print("No Unicode characters found.")
        return

    print(f"Found {len(all_chars)} unique Unicode characters across files.\n")
    replacements = prompt_replacements(all_chars)

    for filepath in files:
        if filepath in contents:
            process_file(filepath, replacements)

if __name__ == "__main__":
    main()

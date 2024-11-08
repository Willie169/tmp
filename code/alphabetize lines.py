def alphabetize_lines(text):
    lines = text.split('\n')
    lines.sort()
    sorted_text = '\n'.join(lines)
    return sorted_text

input_text = """banana
apple
cherry
date"""

sorted_text = alphabetize_lines(input_text)
print(sorted_text)
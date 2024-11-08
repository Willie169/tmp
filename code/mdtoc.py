import re

def generate_toc(input_file='README.md', output_file='TOC.md', encoding='utf-8'):
    # Regular expression to match ## and ### headers
    header_regex = r'^(?P<level>#{2,3})\s+(?P<title>.+?)\s*$'
    code_block_regex = r'(`{3}|\s*#)'  # Matches code blocks and comments

    toc = []
    in_code_block = False

    # Read the markdown content from the input file
    try:
        with open(input_file, 'r', encoding=encoding) as f:
            markdown_content = f.read()
    except FileNotFoundError:
        print(f"Error: The file '{input_file}' was not found.")
        return
    except Exception as e:
        print(f"Error reading '{input_file}': {e}")
        return
    
    # Iterate through each line in the markdown content
    for line in markdown_content.splitlines():
        # Check if the line starts a code block
        if re.match(r'```', line):
            in_code_block = not in_code_block  # Toggle in_code_block status

        # If we are in a code block, skip header checks
        if in_code_block:
            continue

        # Match headers only if outside of code blocks
        match = re.match(header_regex, line)
        if match:
            level = match.group('level')
            title = match.group('title')
            # Convert the title into a URL-friendly format
            link = title.lower().replace(' ', '-').replace('\'', '').replace('\"', '')
            link = re.sub(r'[^a-z0-9\-]', '', link)  # Remove any unwanted characters
            
            if level == '##':  # Level 2 header
                toc.append(f"- [{title}](#{link})")
            elif level == '###':  # Level 3 header
                toc.append(f"  - [{title}](#{link})")
    
    # Write the generated TOC to the output file
    try:
        with open(output_file, 'w', encoding=encoding) as f:
            f.write('\n'.join(toc))
        print(f"Table of Contents successfully generated and written to '{output_file}'.")
    except Exception as e:
        print(f"Error writing to '{output_file}': {e}")

# Example usage
if __name__ == "__main__":
    generate_toc()  # Uses default input and output file names and encoding
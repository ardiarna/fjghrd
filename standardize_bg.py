import os
import re

standard_bg = """image: DecorationImage(
                image: AssetImage('assets/images/line-blue.png'),
                alignment: Alignment.topRight,
                repeat: ImageRepeat.repeatY,
                fit: BoxFit.fitWidth,
                opacity: 0.1,
              )"""

def process_file(filepath):
    with open(filepath, 'r') as f:
        content = f.read()
        
    # Find all DecorationImage blocks containing line-blue.png
    # The regex looks for DecorationImage( ... )
    pattern = re.compile(r'image:\s*DecorationImage\(\s*image:\s*AssetImage\(\'assets/images/line-blue\.png\'\),.*?\)[\s,]*\)', re.DOTALL)
    
    def repl(match):
        # determine indentation
        start_index = match.start()
        # count spaces from last newline
        last_newline = content.rfind('\n', 0, start_index)
        indent_len = start_index - last_newline - 1
        indent = ' ' * indent_len
        
        replacement = """image: DecorationImage(
___indent___  image: AssetImage('assets/images/line-blue.png'),
___indent___  alignment: Alignment.topRight,
___indent___  repeat: ImageRepeat.repeatY,
___indent___  fit: BoxFit.fitWidth,
___indent___  opacity: 0.1,
___indent___)"""
        replacement = replacement.replace('___indent___', indent)
        return replacement

    new_content = pattern.sub(repl, content)
    
    if new_content != content:
        with open(filepath, 'w') as f:
            f.write(new_content)
        print(f"Updated {filepath}")

for root, dirs, files in os.walk('lib/views'):
    for file in files:
        if file.endswith('.dart'):
            process_file(os.path.join(root, file))


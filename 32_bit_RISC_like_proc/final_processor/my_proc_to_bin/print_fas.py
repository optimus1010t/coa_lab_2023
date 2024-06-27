file_path = 'test_out.txt'  # Replace 'your_file.txt' with the path to your .txt file

with open(file_path, 'r') as file:
    for line_number, line_content in enumerate(file, start=0):
        print(f"inst_regs[{line_number}]= 32'b{line_content.strip()};")

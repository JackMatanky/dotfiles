def palindrome_test(phrase: str) -> bool:
    alpha_num_list: list[str] = [char.lower() for char in phrase if char.isalnum()]
    return alpha_num_list == alpha_num_list[::-1]

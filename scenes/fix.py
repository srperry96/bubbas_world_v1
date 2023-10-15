#SCRIPT TO FIX CORRUPTED main.tscn FILE. BAD WAV FILE IN AUDIOSTREAMPLAYER CAUSED CRASH ON OPENING.
#THIS SCRIPT COPIES THE TSCN FILE, IGNORING THE BAD DATA. IT FIXED THE ISSUE AT THE TIME. MIGHT COME IN
#HANDY LATER ON...

with open("main.tscn") as f:
    lines = [line.rstrip() for line in f]


lines.pop(85)

# print(lines)

with open("new_main.tscn", 'w') as f:
    for line in lines:
        f.write(line + "\n")
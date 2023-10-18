#!/usr/bin/env python3

import sys
import time
from termcolor import colored
from terminaltables import SingleTable

# Define ASCII art
BANNER = '''
  ____             __                                      
 / ___| ___   __ _| |_ __ _ _ __   __ _  __ _  ___ _ __ 
| |  _ / _ \ / _` | __/ _` | '_ \ / _` |/ _` |/ _ \ '__|
| |_| | (_) | (_| | || (_| | | | | (_| | (_| |  __/ |   
 \____|\___/ \__,_|\__\__,_|_| |_|\__,_|\__, |\___|_|   
                                        |___/           
'''

# Define command usage
USAGE = '''
Usage: statusCode0.py [OPTION]...

Options:
  --rules\tPrint hackathon rules
  --help\tPrint this help message
  --tracks\tPrint available tracks
  --prizes\tPrint information about prizes
  --venue\tPrint hackathon venue details
  --date\tPrint hackathon date
  --timeline\tPrint hackathon timeline
'''

# Define tracks
TRACKS = [
    ['Track 1', 'Description of Track 1'],
    ['Track 2', 'Description of Track 2'],
    ['Track 3', 'Description of Track 3']
]

# Define prizes
PRIZES = [
    ['Prize 1', 'Description of Prize 1'],
    ['Prize 2', 'Description of Prize 2'],
    ['Prize 3', 'Description of Prize 3']
]

# Print text with typewriter effect
def typewriter_print(text, delay=0.05):
    for char in text:
        sys.stdout.write(char)
        sys.stdout.flush()
        time.sleep(delay)

# Print tracks in a table with typewriter effect
def print_tracks():
    table_data = [['Track', 'Description']] + TRACKS
    table = SingleTable(table_data)
    table.title = 'Available Tracks'
    typewriter_print(colored(table.table, 'cyan'))

# Print prizes in a table with typewriter effect
def print_prizes():
    table_data = [['Prize', 'Description']] + PRIZES
    table = SingleTable(table_data)
    table.title = 'Prizes'
    typewriter_print(colored(table.table, 'cyan'))

# Parse command line arguments
args = sys.argv[1:]
if not args:
    typewriter_print(colored(BANNER, 'green'))
    typewriter_print(colored(USAGE, 'cyan'))
    sys.exit()

for arg in args:
    if arg == '--rules':
        typewriter_print(colored('Hackathon Rules:\n\n1. Rule 1\n2. Rule 2\n3. Rule 3', 'yellow'))
    elif arg == '--tracks':
        print_tracks()
    elif arg == '--prizes':
        print_prizes()
    elif arg == '--venue':
        typewriter_print(colored('Venue:\n\nHackathon Venue Address', 'yellow'))
    elif arg == '--date':
        typewriter_print(colored('Date:\n\nHackathon Date', 'yellow'))
    elif arg == '--timeline':
        typewriter_print(colored('Timeline:\n\nHackathon Timeline', 'yellow'))
    elif arg == '--help':
        typewriter_print(colored(USAGE, 'green'))
        sys.exit()
    else:
        typewriter_print(colored(f'Unknown option: {arg}', 'red'))
        typewriter_print(colored(USAGE, 'cyan'))
        sys.exit(1)


from collections import defaultdict

def tsv_iter(f):
    first_line = True
    for line in file:
        values = line.strip().split('\t')
        if first_line:
            names = values
            first_line = False
        elif len(values) == len(names):
            yield dict(zip(names, values))

class CelMappings:
    def __init__(self):
        self.tiles = defaultdict(int)
        self.units = set()

cel_mappings = defaultdict(CelMappings)

with open('AutoMap.txt') as file:
    num_defs = 0
    for row in tsv_iter(file):
        for n in range(4):
            cel = int(row[f'Cel{n+1}'])
            if cel >= 0:
                cel_mappings[cel].tiles[row['LevelName']] += 1
                num_defs += 1
    print('Loaded', num_defs, 'tile mappings')

with open('objects.txt') as file:
    num_defs = 0
    for row in tsv_iter(file):
        for n in range(4):
            cel = int(row['AutoMap'])
            if cel:
                name = f"{row['Class']} -- {row['Name']} -- {row['description - not loaded']}"
                cel_mappings[cel].units.add(name)
                num_defs += 1
    print('Loaded', num_defs, 'unit mappings')

if __name__ == '__main__':
    print()
    while True:
        cel = input('Tile ID to look up: ')
        try:
            cel = int(cel, 10)
        except ValueError:
            print('Please enter the tile ID as a single integer.')
            print('For example, Default06/Tiles_17.png would be entered as "617".')
            continue
        
        mapping = cel_mappings.get(cel, None)
        if mapping:
            for level, count in mapping.tiles.items():
                print(f'[TILE] Act {level}: {count} different mappings.')
            for unit in mapping.units:
                print(f'[UNIT] {unit}')
        else:
            print(f'Unused.')
        print()

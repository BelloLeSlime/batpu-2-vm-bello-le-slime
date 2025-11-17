from assembler import assemble
from schematic import make_schematic
import sys
import os

def main():
    #args = sys.argv[1:]
    args = ["test", "programs/"]
    program = args[0]
    
    as_filename = f'assembler/programs/{program}.as'
    mc_filename = f'assembler/programs/{program}.mc'
    schem_filename = f'assembler/programs/{program}program.schem'

    assemble(as_filename, mc_filename)
    make_schematic(mc_filename, schem_filename)

if __name__ == '__main__':
    main()
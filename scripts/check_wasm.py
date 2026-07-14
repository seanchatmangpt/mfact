import struct

def check_wasm(filename):
    with open(filename, 'rb') as f:
        data = f.read()
    
    print("WASM File size:", len(data))
    if data[:4] != b'\x00asm':
        print("Not a valid WASM file")
        return
    
    idx = 8
    
    def read_varuint(data, offset):
        res = 0
        shift = 0
        while True:
            b = data[offset]
            offset += 1
            res |= (b & 0x7f) << shift
            if not (b & 0x80):
                break
            shift += 7
        return res, offset

    def read_string(data, offset):
        length, offset = read_varuint(data, offset)
        s = data[offset:offset+length].decode('utf-8')
        return s, offset + length

    sections = {
        1: "Type",
        2: "Import",
        3: "Function",
        4: "Table",
        5: "Memory",
        6: "Global",
        7: "Export",
        8: "Start",
        9: "Element",
        10: "Code",
        11: "Data",
        12: "DataCount"
    }

    while idx < len(data):
        sect_type = data[idx]
        idx += 1
        sect_size, idx = read_varuint(data, idx)
        next_sect = idx + sect_size
        
        name = sections.get(sect_type, f"Unknown ({sect_type})")
        print(f"Section {name}: size {sect_size} bytes")
        
        if sect_type == 2: # Imports
            num_imports, cur = read_varuint(data, idx)
            print(f"  Imports ({num_imports}):")
            for _ in range(num_imports):
                mod, cur = read_string(data, cur)
                field, cur = read_string(data, cur)
                kind = data[cur]
                cur += 1
                if kind == 0:
                    _, cur = read_varuint(data, cur)
                elif kind == 1:
                    cur += 2
                elif kind == 2:
                    cur += 1
                elif kind == 3:
                    cur += 2
                print(f"    {mod}.{field} (kind: {kind})")
                
        elif sect_type == 7: # Exports
            num_exports, cur = read_varuint(data, idx)
            print(f"  Exports ({num_exports}):")
            for _ in range(num_exports):
                name, cur = read_string(data, cur)
                kind = data[cur]
                cur += 1
                index, cur = read_varuint(data, cur)
                print(f"    {name} (kind: {kind}, index: {index})")
                
        idx = next_sect

check_wasm('web/mfact-ui/src/assets/AtomVM_bridge.wasm')

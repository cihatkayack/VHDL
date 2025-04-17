import imageio
import math

def get_color_bits(im, y, x):
    r = format(im[y][x][0], 'b').zfill(8)[0:4]
    g = format(im[y][x][1], 'b').zfill(8)[0:4]
    b = format(im[y][x][2], 'b').zfill(8)[0:4]
    return r + g + b

def rom_12_bit_vhdl(name, im, mask=False, rem_x=-1, rem_y=-1):
    if rem_x == -1 or rem_y == -1:
        a = "000000000000"
    else:
        a = get_color_bits(im, rem_x, rem_y)

    file_name = name.split('.')[0] + "_rom.vhd"
    f = open(file_name, 'w')

    y_max, x_max, z = im.shape
    total_pixels = x_max * y_max
    addr_width = math.ceil(math.log2(total_pixels))

    f.write(f"library IEEE;\nuse IEEE.STD_LOGIC_1164.ALL;\nuse IEEE.STD_LOGIC_ARITH.ALL;\nuse IEEE.STD_LOGIC_UNSIGNED.ALL;\n\n")
    f.write(f"entity {name.split('.')[0]}_rom is\n")
    f.write(f"    Port (\n")
    f.write(f"        clk         : in  std_logic;\n")
    f.write(f"        address     : in  std_logic_vector({addr_width - 1} downto 0);\n")
    f.write(f"        color_data  : out std_logic_vector(11 downto 0)\n")
    f.write(f"    );\nend {name.split('.')[0]}_rom;\n\n")

    f.write(f"architecture Behavioral of {name.split('.')[0]}_rom is\n")
    f.write(f"    type rom_type is array (0 to {total_pixels - 1}) of std_logic_vector(11 downto 0);\n")
    f.write(f"    signal rom : rom_type := (\n")

    idx = 0
    for y in range(y_max):
        for x in range(x_max):
            pixel = get_color_bits(im, y, x)
            if mask and pixel == a:
                pixel = "000000000000"
            line_end = ",\n" if idx < total_pixels - 1 else "\n"
            f.write(f'        {idx} => "{pixel}"{line_end}')
            idx += 1

    f.write(f"    );\n")
    f.write(f"begin\n")
    f.write(f"    process(clk)\n")
    f.write(f"    begin\n")
    f.write(f"        if rising_edge(clk) then\n")
    f.write(f"            color_data <= rom(to_integer(unsigned(address)));\n")
    f.write(f"        end if;\n")
    f.write(f"    end process;\n")
    f.write(f"end Behavioral;\n")

    f.close()

def generate_vhdl(name, rem_x=-1, rem_y=-1):
    im = imageio.imread(name)
    print("width: " + str(im.shape[1]) + ", height: " + str(im.shape[0]))
    rom_12_bit_vhdl(name, im, mask=False, rem_x=rem_x, rem_y=rem_y)

# Kullanım:
generate_vhdl("frog_up.bmp")
generate_vhdl("frog_down.bmp")
generate_vhdl("frog_left.bmp")
generate_vhdl("frog_right.bmp")
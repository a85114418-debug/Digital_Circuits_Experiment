-- 一位半减器
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity half_subtractor is
    Port (
        a    : in  STD_LOGIC;  -- 被减数
        b    : in  STD_LOGIC;  -- 减数
        diff : out STD_LOGIC;  -- 差值
        bout : out STD_LOGIC   -- 借位输出
    );
end half_subtractor;

architecture Behavioral of half_subtractor is
begin
    diff <= a xor b;
    bout <= (not a) and b;
end Behavioral;

-- 一位全减器
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity full_subtractor is
    Port (
        a    : in  STD_LOGIC;  -- 被减数
        b    : in  STD_LOGIC;  -- 减数
        bin  : in  STD_LOGIC;  -- 借位输入
        diff : out STD_LOGIC;  -- 差值
        bout : out STD_LOGIC   -- 借位输出
    );
end full_subtractor;

architecture Behavioral of full_subtractor is
begin
    diff <= a xor b xor bin;
    bout <= ((not a) and b) or ((not (a xor b)) and bin);
end Behavioral;

-- 四位全减器
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity four_bit_subtractor is
    Port (
        a    : in  STD_LOGIC_VECTOR(3 downto 0); -- 4位被减数
        b    : in  STD_LOGIC_VECTOR(3 downto 0); -- 4位减数
        bin  : in  STD_LOGIC;                    -- 初始借位输入
        diff : out STD_LOGIC_VECTOR(3 downto 0); -- 4位差值输出
        bout : out STD_LOGIC                     -- 最终借位输出
    );
end four_bit_subtractor;

architecture Structural of four_bit_subtractor is

    -- 声明半减器组件
    component half_subtractor
        Port (
            a    : in  STD_LOGIC;
            b    : in  STD_LOGIC;
            diff : out STD_LOGIC;
            bout : out STD_LOGIC
        );
    end component;

    -- 声明全减器组件
    component full_subtractor
        Port (
            a    : in  STD_LOGIC;
            b    : in  STD_LOGIC;
            bin  : in  STD_LOGIC;
            diff : out STD_LOGIC;
            bout : out STD_LOGIC
        );
    end component;

    -- 定义内部信号，用于级联各级之间的借位
    signal c1, c2, c3 : STD_LOGIC;

begin

    -- 第0位：使用半减器处理最低位
    HS0: half_subtractor port map (
        a    => a(0),
        b    => b(0),
        diff => diff(0),
        bout => c1
    );

    -- 第1位：使用全减器，接收来自第0位的借位
    FS1: full_subtractor port map (
        a    => a(1),
        b    => b(1),
        bin  => c1,
        diff => diff(1),
        bout => c2
    );

    -- 第2位：使用全减器，接收来自第1位的借位
    FS2: full_subtractor port map (
        a    => a(2),
        b    => b(2),
        bin  => c2,
        diff => diff(2),
        bout => c3
    );

    -- 第3位：使用全减器，接收来自第2位的借位，输出最终借位
    FS3: full_subtractor port map (
        a    => a(3),
        b    => b(3),
        bin  => c3,
        diff => diff(3),
        bout => bout
    );

end Structural;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- ==========================================
-- 1. 半减器 (Half Subtractor) 实体与结构体
-- ==========================================
entity half_subtractor is
    Port ( a    : in  STD_LOGIC;  -- 被减数
           b    : in  STD_LOGIC;  -- 减数
           diff : out STD_LOGIC;  -- 差值
           bout : out STD_LOGIC); -- 借位输出
end half_subtractor;

architecture dataflow of half_subtractor is
begin
    diff <= a xor b;              -- 差值：A 异或 B
    bout <= (not a) and b;        -- 借位：A'B
end dataflow;

-- ==========================================
-- 2. 全减器 (Full Subtractor) 实体与结构体
-- ==========================================
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity full_subtractor is
    Port ( a    : in  STD_LOGIC;  -- 被减数
           b    : in  STD_LOGIC;  -- 减数
           bin  : in  STD_LOGIC;  -- 低位借位输入
           diff : out STD_LOGIC;  -- 差值
           bout : out STD_LOGIC); -- 借位输出
end full_subtractor;

architecture dataflow of full_subtractor is
begin
    -- 差值：A 异或 B 异或 Bin
    diff <= a xor b xor bin;      
    -- 借位输出：A'B + (A xnor B)Bin
    bout <= ((not a) and b) or (not(a xor b) and bin); 
end dataflow;

-- ==========================================
-- 3. 顶层模块：4位全减器 (4-bit Subtractor)
-- ==========================================
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sub_4bit is
    Port ( A    : in  STD_LOGIC_VECTOR (3 downto 0); -- 4位被减数
           B    : in  STD_LOGIC_VECTOR (3 downto 0); -- 4位减数
           DIFF : out STD_LOGIC_VECTOR (3 downto 0); -- 4位差值结果
           BOUT : out STD_LOGIC);                    -- 最终借位输出
end sub_4bit;

architecture structural of sub_4bit is
    -- 声明半减器组件
    component half_subtractor
        Port ( a, b : in STD_LOGIC;
               diff, bout : out STD_LOGIC);
    end component;

    -- 声明全减器组件
    component full_subtractor
        Port ( a, b, bin : in STD_LOGIC;
               diff, bout : out STD_LOGIC);
    end component;

    -- 声明内部信号，用于连接各级减器之间的借位
    signal borrow : STD_LOGIC_VECTOR(2 downto 0); 
begin
    -- 实例化：第0位（最低位），无外部借位输入，使用半减器
    HS0: half_subtractor 
        port map(a => A(0), b => B(0), diff => DIFF(0), bout => borrow(0));

    -- 实例化：第1位，接收第0位的借位，使用全减器
    FS1: full_subtractor 
        port map(a => A(1), b => B(1), bin => borrow(0), diff => DIFF(1), bout => borrow(1));

    -- 实例化：第2位，接收第1位的借位，使用全减器
    FS2: full_subtractor 
        port map(a => A(2), b => B(2), bin => borrow(1), diff => DIFF(2), bout => borrow(2));

    -- 实例化：第3位（最高位），接收第2位的借位，输出最终借位给 BOUT
    FS3: full_subtractor 
        port map(a => A(3), b => B(3), bin => borrow(2), diff => DIFF(3), bout => BOUT);

end structural;
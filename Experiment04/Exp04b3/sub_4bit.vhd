-- 一位半减器
-- 引入IEEE标准库
library IEEE;
-- 使用IEEE库中的STD_LOGIC_1164包，该包定义了STD_LOGIC等标准逻辑数据类型
use IEEE.STD_LOGIC_1164.ALL;

-- 定义实体，实体描述了模块的外部接口（输入和输出端口）
entity half_subtractor is
    Port (
        a    : in  STD_LOGIC;  -- 输入端口，类型为STD_LOGIC，代表被减数
        b    : in  STD_LOGIC;  -- 输入端口，类型为STD_LOGIC，代表减数
        diff : out STD_LOGIC;  -- 输出端口，类型为STD_LOGIC，代表差值
        bout : out STD_LOGIC   -- 输出端口，类型为STD_LOGIC，代表借位输出（注意此处无分号，因为这是端口列表的最后一项）
    );
end half_subtractor; -- 实体定义结束

-- 定义结构体，结构体描述了实体内部的具体逻辑功能或行为
architecture Behavioral of half_subtractor is
-- 此处可以声明内部信号、组件等，本例中不需要
begin
    -- 并发信号赋值语句：差值等于a异或b（相同为0，不同为1）
    diff <= a xor b;
    -- 并发信号赋值语句：借位输出等于a的非与b（当a为0且b为1时借位为1）
    bout <= (not a) and b;
end Behavioral; -- 结构体定义结束




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
    diff <= b xor a xor bin;
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

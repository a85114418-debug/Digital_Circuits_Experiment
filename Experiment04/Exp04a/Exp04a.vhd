-- 1. 引入标准库（必须包含，才能使用STD_LOGIC类型）
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- 2. 定义实体 Entity（定义芯片的外部引脚/接口）
--MUX是英文 Multiplexer（多路选择器）的标准缩写,41：代表4选1
ENTITY MUX41 IS
PORT(
d0 : in STD_LOGIC;
d1 : in STD_LOGIC;
d2 : in STD_LOGIC;
d3 : in STD_LOGIC;
sel :in STD_LOGIC_VECTOR(1 DOWNTO 0);-- VECTOR 表示多位总线，1 downto 0 代表2位宽 (sel[1], sel[0])
y :OUT STD_LOGIC);
END ENTITY MUX41;

ARCHITECTURE One OF MUX41 IS
begin
	with sel select
		 y <= d0 when "00",
		  d1 when "01",
		  d2 when "10",
		  d3 when "11",
		  '0' when others;
		 
end ARCHITECTURE One;  
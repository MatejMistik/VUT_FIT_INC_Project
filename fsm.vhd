-- fsm.vhd: Finite State Machine
-- Author(s): 
--
library ieee;
use ieee.std_logic_1164.all;
-- ----------------------------------------------------------------------------
--                        Entity declaration
-- ----------------------------------------------------------------------------
entity fsm is
port(
   CLK         : in  std_logic;
   RESET       : in  std_logic;

   -- Input signals
   KEY         : in  std_logic_vector(15 downto 0);
   CNT_OF      : in  std_logic;

   -- Output signals
   FSM_CNT_CE  : out std_logic;
   FSM_MX_MEM  : out std_logic;
   FSM_MX_LCD  : out std_logic;
   FSM_LCD_WR  : out std_logic;
   FSM_LCD_CLR : out std_logic
);
end entity fsm;

-- ----------------------------------------------------------------------------
--                      Architecture declaration
-- ----------------------------------------------------------------------------
architecture behavioral of fsm is
   type t_state is ( INCORRECT_CHAR, ACCESS_DENIED, ACCESS_GRANTED, CHAR_1, CHAR_2, CHAR_3, CHAR_4, CHAR_5, CHAR_6, CHAR_7, CHAR_8, CHAR_9, CHAR_10, TEST_ACCESS, FINISH);
   signal present_state, next_state : t_state;

begin
-- -------------------------------------------------------
sync_logic : process(RESET, CLK)
begin
   if (RESET = '1') then
      present_state <= CHAR_1;
   elsif (CLK'event AND CLK = '1') then
      present_state <= next_state;
   end if;
end process sync_logic;

-- -------------------------------------------------------
next_state_logic : process(present_state, KEY, CNT_OF)
variable option : boolean;
begin
   case (present_state) is
   -- - - - - - - - - - - - - - - - - - - - - - -
   when CHAR_1 =>
      next_state <= CHAR_1;
      if (KEY(1) = '1') then
		 option := TRUE ;
         next_state <= CHAR_2;
      elsif (KEY(3) = '1') then
		 option := FALSE ;
         next_state <= CHAR_2;
      elsif (KEY(15) = '1') then
         next_state <= ACCESS_DENIED;
	  elsif (KEY(14 downto 0) /= "000000000000000") then
         next_state <= INCORRECT_CHAR;
      end if;
   -- - - - - - - - - - - - - - - - - - - - - - -
   when CHAR_2 =>
      next_state <= CHAR_2;
      if (KEY(9) = '1') and (option = TRUE ) then
         next_state <= CHAR_3;
      elsif (KEY(4) = '1') and (option = FALSE) then
         next_state <= CHAR_3;
      elsif (KEY(15) = '1') then
         next_state <= ACCESS_DENIED;
	  elsif (KEY(14 downto 0) /= "000000000000000") then
         next_state <= INCORRECT_CHAR;
      end if;
   -- - - - - - - - - - - - - - - - - - - - - - -
   when CHAR_3 =>
      next_state <= CHAR_3;
      if (KEY(7) = '1') and (option = TRUE) then
         next_state <= CHAR_4;
      elsif (KEY(5) = '1') and (option = FALSE) then
         next_state <= CHAR_4;
      elsif (KEY(15) = '1') then
         next_state <= ACCESS_DENIED;
	  elsif (KEY(14 downto 0) /= "000000000000000") then
         next_state <= INCORRECT_CHAR;
      end if;
   -- - - - - - - - - - - - - - - - - - - - - - -
   when CHAR_4 =>
      next_state <= CHAR_4;
      if (KEY(2) = '1') then
         next_state <= CHAR_5;
      elsif (KEY(15) = '1') then
         next_state <= ACCESS_DENIED;
	  elsif (KEY(14 downto 0) /= "000000000000000") then
         next_state <= INCORRECT_CHAR;
      end if;
   -- - - - - - - - - - - - - - - - - - - - - - -
   when CHAR_5 =>
      next_state <= CHAR_5;
      if (KEY(6) = '1') and (option = TRUE) then
         next_state <= CHAR_6;
      elsif (KEY(1) = '1') and (option = FALSE) then
         next_state <= CHAR_6;
      elsif (KEY(15) = '1') then
         next_state <= ACCESS_DENIED;
	  elsif (KEY(14 downto 0) /= "000000000000000") then
         next_state <= INCORRECT_CHAR;
      end if;
   -- - - - - - - - - - - - - - - - - - - - - - -
   when CHAR_6 =>
      next_state <= CHAR_6;
      if (KEY(3) = '1') and (option = TRUE) then
         next_state <= CHAR_7;
      elsif (KEY(0) = '1') and (option = FALSE) then
         next_state <= CHAR_7;
      elsif (KEY(15) = '1') then
         next_state <= ACCESS_DENIED;
	  elsif (KEY(14 downto 0) /= "000000000000000") then
         next_state <= INCORRECT_CHAR;
      end if;
   -- - - - - - - - - - - - - - - - - - - - - - -
   when CHAR_7 =>
      next_state <= CHAR_7;
      if (KEY(0) = '1')  and (option = TRUE) then
         next_state <= CHAR_8;
		elsif (KEY(2) = '1') and (option = FALSE) then
         next_state <= CHAR_8;	
      elsif (KEY(15) = '1') then
         next_state <= ACCESS_DENIED;
	  elsif (KEY(14 downto 0) /= "000000000000000") then
         next_state <= INCORRECT_CHAR;
      end if;
   -- - - - - - - - - - - - - - - - - - - - - - -
   when CHAR_8 =>
      next_state <= CHAR_8;
      if (KEY(0) = '1') and (option = TRUE) then
         next_state <= CHAR_9;
      elsif (KEY(6) = '1') and (option = FALSE) then
         next_state <= CHAR_9;
      elsif (KEY(15) = '1') then
         next_state <= ACCESS_DENIED;
	  elsif (KEY(14 downto 0) /= "000000000000000") then
         next_state <= INCORRECT_CHAR;
      end if;
   -- - - - - - - - - - - - - - - - - - - - - - -
   when CHAR_9 =>
      next_state <= CHAR_9;
      if (KEY(8) = '1') and (option = TRUE) then
         next_state <= CHAR_10;
      elsif (KEY(4) = '1') and (option = FALSE) then
         next_state <= CHAR_10;
      elsif (KEY(15) = '1') then
         next_state <= ACCESS_DENIED;
	  elsif (KEY(14 downto 0) /= "000000000000000") then
         next_state <= INCORRECT_CHAR;
      end if;
   -- - - - - - - - - - - - - - - - - - - - - - -
   when CHAR_10 =>
      next_state <= CHAR_10;
      if (KEY(2) = '1') and (option = TRUE) then
         next_state <= TEST_ACCESS;
      elsif (KEY(4) = '1') and (option = FALSE) then
         next_state <= TEST_ACCESS;
      elsif (KEY(15) = '1') then
         next_state <= ACCESS_DENIED;
	  elsif (KEY(14 downto 0) /= "000000000000000") then
         next_state <= INCORRECT_CHAR;
      end if;
   -- - - - - - - - - - - - - - - - - - - - - - -
   when TEST_ACCESS =>
      next_state <= TEST_ACCESS;
      if (KEY(15) = '1') then
         next_state <= ACCESS_GRANTED;
	  elsif (KEY(14 downto 0) /= "000000000000000") then
         next_state <= INCORRECT_CHAR;
      end if;
   -- - - - - - - - - - - - - - - - - - - - - - -
	when INCORRECT_CHAR =>
      next_state <= INCORRECT_CHAR;
      if (KEY(15) = '1') then
         next_state <= ACCESS_DENIED;
      end if;
	-- - - - - - - - - - - - - - - - - - - - - - -	
	when ACCESS_GRANTED =>
      next_state <= ACCESS_GRANTED;
      if (CNT_OF = '1') then
         next_state <= FINISH;
      end if;
	-- - - - - - - - - - - - - - - - - - - - - - -	
   when ACCESS_DENIED =>
      next_state <= ACCESS_DENIED;
      if (CNT_OF = '1') then
         next_state <= FINISH;
      end if;
   -- - - - - - - - - - - - - - - - - - - - - - -
   when FINISH =>
      next_state <= FINISH;
      if (KEY(15) = '1') then
         next_state <= CHAR_1; 
      end if;
   -- - - - - - - - - - - - - - - - - - - - - - -
   when others =>
	next_state <= CHAR_1;
   end case;
end process next_state_logic;

-- -------------------------------------------------------
output_logic : process(present_state, KEY)
begin
   FSM_CNT_CE     <= '0';
   FSM_MX_MEM     <= '0';
   FSM_MX_LCD     <= '0';
   FSM_LCD_WR     <= '0';
   FSM_LCD_CLR    <= '0';

   case (present_state) is
   -- - - - - - - - - - - - - - - - - - - - - - -
   when ACCESS_DENIED =>
      FSM_CNT_CE     <= '1';
      FSM_MX_LCD     <= '1';
      FSM_LCD_WR     <= '1';
	-- - - - - - - - - - - - - - - - - - - - - - -	
	when ACCESS_GRANTED =>
      FSM_CNT_CE     <= '1';
      FSM_MX_LCD     <= '1';
		FSM_MX_MEM     <= '1';
      FSM_LCD_WR     <= '1';
   -- - - - - - - - - - - - - - - - - - - - - - -
   when FINISH =>
      if (KEY(15) = '1') then
         FSM_LCD_CLR    <= '1';
      end if;
   -- - - - - - - - - - - - - - - - - - - - - - -
   when others =>
	if (KEY(15) = '1') then
         FSM_LCD_CLR <= '1';
      elsif (KEY(14 downto 0) /= "000000000000000") then
         FSM_LCD_WR <= '1';
   end if;		
   end case;
end process output_logic;

end architecture behavioral;


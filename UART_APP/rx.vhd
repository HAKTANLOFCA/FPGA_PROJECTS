

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity UART_RX_MODULE is

port(
clk:in std_logic; -- clock girişimi atadım
rst:in std_logic; -- reset girişimi atadım
rx_i:in std_logic; -- rx girişimi atadım
data_out:out std_logic_vector(7 downto 0); -- data çıkışını atadım
rx_exit_control:out std_logic -- gönderme işleminin bittiğini anlamak için bu çıkışı oluşturdum


);




end UART_RX_MODULE;

architecture Behavioral of UART_RX_MODULE is
type states is (S_IDLE,S_START,S_DATA,S_STOP); --state adımlarımı oluşturdum
signal state :states :=S_IDLE; -- başlangıç state'ini atadım

signal cnt:integer range 0 to 32768; -- 2^15 değeri ( max stop bitine kadar sayacağı için bu değeri girdim)
signal bit_cnt:integer range 0 to 8; --bitlerimi sayacak counter'ı atadım
signal shift_reg:std_logic_vector(7 downto 0); -- datama değer atayamayacağım için shift regester oluşturdum

begin

data_out <= shift_reg; --atama yaptığım shift rester'ını data çıkışıma atadım

MAIN:process(clk)
begin
    if(rising_edge(clk)) then
        if(rst = '0') then --reset sıfır olunca olcak değer atamalarını yaptım
            shift_reg <= (others => '0');
            rx_exit_control <='0';
            cnt<=0;
            bit_cnt<=0;
        else
            
            case state is
            
                when S_IDLE =>
                
                    
                    rx_exit_control <='0'; --IDLE state'inde çıkış kontrolüm 0 durumunda
                
                    if(rx_i <= '0') then  --rx low olunca
                        
                        state <= S_START; -- start STATE'ine git
                        
                    
                    
                    end if;
                
                
                when S_START =>
                
                    if(cnt = 5208) then   --1 bitin gönderim süresinin yarısı kadar süre geçince data kısmına git
                        
                        state <= S_DATA;
                        
                        cnt<=0; --cnt sıfırlayarak git
                        bit_cnt<=0; --bit_cnt sıfırlayarak git
                    else
                         cnt <= cnt + 1; -- 5208 e ulaşıncaya kadar arttır
                    
                    
                    
                    
                    
                    end if;
                    
                
                
                
                when S_DATA =>
                
                    if(bit_cnt = 8) then -- bitlerin gönderimi bitince
                        
                        state<=S_STOP; -- stopa git
                        bit_cnt<=0; --bit counter'ı sıfırlayarak git
                        
                        
                        cnt<=0; -- counter'ı sıfırlayarak git
                    
                    else
                    
                        if(cnt = 10416) then -- eğer bitlerin gönderimi bitmediyse 1 bit süre geçince
                        
                            shift_reg<=rx_i & (shift_reg(7 downto 1)); -- kaydırarak biti shift register'a ata
                            bit_cnt <= bit_cnt +1; -- bit counter'ı arttır
                            cnt <= 0; -- counter'ı sıfırla
                        else
                        
                            cnt <= cnt + 1; -- counter'ı arttır
                        
                        
                        end if;
                    
                    
                    
                    end if;
                            
                
                
                when S_STOP =>
                
        
                    if(cnt = 10416) then  -- 1 bit için gönderilcek süre geçince
                        state <= S_IDLE;         -- yeni bilgi için IDLE'ye git 
                        rx_exit_control <= '1';  -- çıkış kontrolümüz 1 oldu
                        cnt <= 0; -- counterı sıfırlayarak git
                   else
                   cnt <= cnt +     1;  --counter'ı 1 arttır
                   
                   end if;          
        
        
        
         end case;
        end if;
    end if;
end process MAIN;











end Behavioral;

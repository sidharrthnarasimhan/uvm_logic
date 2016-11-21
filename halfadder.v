module halfadder(in_a, in_b, clock,reset, carry, sum);
input a;
input b;
output reg carry;
output reg result;
input reset, clock;
always@(posedge clock)
     begin
      if(reset == 1)
       begin
        carry <=1'b0;
        sum <=1'b0;
       end
      else
       begin
        carry <= in_a & in_b;
        sum <= in_a ^ in_b;
       end
     end
endmodule
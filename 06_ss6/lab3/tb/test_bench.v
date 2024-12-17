module test_bench;
  reg [3:0] a, b;
  //wire z;
  
  //top u_dut(.*);
  
  initial begin
    // Bitwise operators
    $display("01.Bitwise XOR             : 4'b1010 ^ 4'b0011     = 4'b%b", 4'b1010 ^ 4'b0011);
    $display("02.Bitwise AND             : 4'b1010 & 4'b0011     = 4'b%b", 4'b1010 & 4'b0011);
    $display("03.Bitwise OR              : 4'b1010 | 4'b0011     = 4'b%b", 4'b1010 | 4'b0011);
    $display("04.Bitwise INV             : ~4'b1010              = 4'b%b", ~4'b1010);

    // Arithmetic operators
    $display("05.Addition                : 4'b1010 + 4'b0011     = 4'b%b", 4'b1010 + 4'b0011);
    $display("06.Subtraction             : 4'b1010 - 4'b0011     = 4'b%b", 4'b1010 - 4'b0011);
    $display("07.Multiplication          : 4'b0101 * 4'b0010     = 4'b%b", 4'b0101 * 4'b0010);
    $display("08.Division                : 4'b1010 / 4'b0010     = 4'b%b", 4'b1010 / 4'b0010);
    $display("09.Modulo                  : 4'b1011 %% 4'b0010     = 4'b%b", 4'b1011 % 4'b0010);

    // Comparison operators
    $display("10.Greater                 : 4'b1010 > 4'b1000     = 1'b%b", 4'b1010 > 4'b1000);
    $display("11.Greater or Equal        : 4'b1010 >= 4'b1010    = 1'b%b", 4'b1010 >= 4'b1010);
    $display("12.Less                    : 4'b1010 < 4'b1001     = 1'b%b", 4'b1010 < 4'b1001);
    $display("13.Less or Equal           : 4'b1010 <= 4'b1010    = 1'b%b", 4'b1010 <= 4'b1010);

    // Equality operators
    $display("14.1.Logical Equality      : 4'b1100 == 4'b1100    = 1'b%b", 4'b1100 == 4'b1100);
    $display("14.2.Logical Equality      : 4'b1100 == 4'b110x    = 1'b%b", 4'b1100 == 4'b110x);
    $display("15.1.Logical Inequality    : 4'b1100 != 4'b1100    = 1'b%b", 4'b1100 != 4'b1100);
    $display("15.2.Logical Inequality    : 4'b1100 != 4'b110x    = 1'b%b", 4'b1100 != 4'b110x);
    $display("16.1.Case Equality         : 4'b1100 === 4'b1100   = 1'b%b", 4'b1100 === 4'b1100);
    $display("16.2.Case Equality         : 4'b1100 === 4'b110x   = 1'b%b", 4'b1100 === 4'b110x);
    $display("17.1.Case Inequality       : 4'b1100 !== 4'b1100   = 1'b%b", 4'b1100 !== 4'b1100);
    $display("17.2.Case Inequality       : 4'b1100 !== 4'b110x   = 1'b%b", 4'b1100 !== 4'b110x);

    // Logical operators
    a = 5; b = 3;
    $display("18.1.Logical And           : a=5,b=3 = ((a==5) && (b==3)) = %b", ((a==5) && (b==3)));
    $display("18.2.Logical And           : 4'b1010 && 4'b0001    = 1'b%b", 4'b1010 && 4'b0001);
    $display("19.1.Logical OR            : a=5,b=3 = ((a!=5) || (b!=3)) = %b", ((a!=5) || (b!=3)));
    $display("19.2.Logical OR            : 4'b0010 || 4'b0001    = 1'b%b", 4'b0010 || 4'b0001);
    $display("20.1.Logical Invert        : !1'b1                 = 1'b%b", !1'b1);
    $display("20.2.Logical Invert        : !4'b0001              = 1'b%b", !4'b0001);

    // Shift operators
    $display("21.Logical Shift Left      : 1 << 2                = 4'b%b", 4'd1 << 4'd2);
    $display("22.Logical Shift Right     : 4'b1101 >> 2          = 4'b%b", 4'b1101 >> 2);

    // Reduction operators
    a = 4'b1011;
    $display("23.Reduction And           : a=4'b1011 --> &a[3:0] = 1'b%b", &a);
    a = 4'b1000;
    $display("24.Reduction Or            : a=4'b1000 --> |a[3:0] = 1'b%b", |a);
    a = 4'b1010;
    $display("25.Reduction XOR           : a=4'b1010 --> ^a[3:0] = 1'b%b", ^a);

    // Concatenation and replication
    a = 4'b1100; b = 3'b001;
    $display("26. Concatenation          : a=4'b1100, b=3'b001 -->{a[3:0],b[2:0]} = 7'b%b", {a[3:0],b[2:0]});
    $display("27. Replication            : {4 {2'b10}}           = 8'b%b", {4 {2'b10}});

    $finish;
  end

endmodule

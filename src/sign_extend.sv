module sign_extend (
    input  logic [31:0] In,
    input  logic [1:0]  ImmSrc,
    output logic [31:0] Imm_Ext
);

    assign Imm_Ext =  (ImmSrc == 2'b00) ? {{20{In[31]}},In[31:20]} : 
                      (ImmSrc == 2'b01) ? {{20{In[31]}},In[31:25],In[11:7]} : '0;
endmodule
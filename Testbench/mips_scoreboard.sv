class mips_scoreboard extends uvm_scoreboard;
  //---------------------------------------
  // declaring pkt_qu to store the pkt's recived from monitor
  //---------------------------------------
  mips_seq_item pkt_qu[$];

  //reg refile memory
  reg [31:0] rf[31:0];
  //reg data memory
  reg [31:0] ram[DMEMORY_WIDTH-1:0];
  //temporal for data
  reg [31:0] temp;

  //---------------------------------------
  //port to recive packets from monitor
  //---------------------------------------
  uvm_analysis_imp#(mips_seq_item, mips_scoreboard) item_collected_export;
  `uvm_component_utils(mips_scoreboard)
  
  //---------------------------------------
  // new - constructor
  //---------------------------------------
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  //---------------------------------------
  // build_phase - create port and initialize local memory
  //---------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
      item_collected_export = new("item_collected_export", this);
  endfunction: build_phase

  //---------------------------------------
  // write task - recives the pkt from monitor and pushes into queue
  //---------------------------------------
  virtual function void write(mips_seq_item pkt);
    pkt_qu.push_back(pkt);
  endfunction : write

  //---------------------------------------
  // run_phase
  //---------------------------------------
  virtual task run_phase(uvm_phase phase);
    mips_seq_item mips_pkt;

    forever begin
      wait(pkt_qu.size() > 0);
      mips_pkt = pkt_qu.pop_front();
      //----------------------------
      case(mips_pkt.p_state)
        7:	/* R-type */
        begin
          `uvm_info(get_type_name(),$sformatf("------ :: [R-TYPE] INS = 0x%h :: ------",mips_pkt.Instr),UVM_LOW)
//           `uvm_info(get_type_name(),$sformatf("[R-TYPE] rs = %d",mips_pkt.Instr[25:21]),UVM_LOW)
//           `uvm_info(get_type_name(),$sformatf("[R-TYPE] rt = %d",mips_pkt.Instr[20:16]),UVM_LOW)
//           `uvm_info(get_type_name(),$sformatf("[R-TYPE] rd = %d",mips_pkt.Instr[15:11]),UVM_LOW)
//           `uvm_info(get_type_name(),$sformatf("[R-TYPE] shamt= %d",mips_pkt.Instr[10:6]),UVM_LOW)
//           `uvm_info(get_type_name(),$sformatf("[R-TYPE] funct= %d",mips_pkt.Instr[5:0]),UVM_LOW)
//           `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)
//           `uvm_info(get_type_name(),$sformatf("[SLT] :: val rs = %0h",rf[mips_pkt.Instr[25:21]]),UVM_LOW)
//           `uvm_info(get_type_name(),$sformatf("[SLT] :: val rt = %0h",rf[mips_pkt.Instr[20:16]]),UVM_LOW)
//           `uvm_info(get_type_name(),$sformatf("[SLT] :: val B = %0h",mips_pkt.B),UVM_LOW)
          case(mips_pkt.Instr[5:0])//funct
          6'b100000:	//add
            if((rf[mips_pkt.Instr[25:21]] + rf[mips_pkt.Instr[20:16]]) == mips_pkt.ALUOut)
            begin
                `uvm_info(get_type_name(),$sformatf("---- [ADD] :: Result is as Expected :: ----"),UVM_LOW)
                `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)
            end
            else
            begin
                `uvm_error(get_type_name(),"---- [ADD] :: Wrong Result :: ----")
                `uvm_info(get_type_name(),$sformatf("[ADD] :: EXPECTED = %0h",(rf[mips_pkt.Instr[25:21]] + rf[mips_pkt.Instr[20:16]])),UVM_LOW)
                `uvm_info(get_type_name(),$sformatf("[ADD] :: ACTUAL = %0h",mips_pkt.ALUOut),UVM_LOW)
                `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)
            end
          6'b100010:	//sub 
            if((rf[mips_pkt.Instr[25:21]] - rf[mips_pkt.Instr[20:16]]) == mips_pkt.ALUOut)
            begin
                `uvm_info(get_type_name(),$sformatf("---- [SUB] :: Result is as Expected :: ----"),UVM_LOW)
                `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)
            end
            else
            begin
                `uvm_error(get_type_name(),"---- [SUB] :: Wrong Result :: ----")
                `uvm_info(get_type_name(),$sformatf("[SUB] :: EXPECTED = %0h",(rf[mips_pkt.Instr[25:21]] - rf[mips_pkt.Instr[20:16]])),UVM_LOW)
                `uvm_info(get_type_name(),$sformatf("[SUB] :: ACTUAL = %0h",mips_pkt.ALUOut),UVM_LOW)
                `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)
            end
          6'b100100:	//and
            if((rf[mips_pkt.Instr[25:21]] & rf[mips_pkt.Instr[20:16]]) == mips_pkt.ALUOut)
            begin
                `uvm_info(get_type_name(),$sformatf("---- [AND] :: Result is as Expected :: ----"),UVM_LOW)
                `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)
            end
            else
            begin
                `uvm_error(get_type_name(),"---- [AND] :: Wrong Result :: ----")
                `uvm_info(get_type_name(),$sformatf("[AND] :: EXPECTED = %0h",(rf[mips_pkt.Instr[25:21]] & rf[mips_pkt.Instr[20:16]])),UVM_LOW)
                `uvm_info(get_type_name(),$sformatf("[AND] :: ACTUAL = %0h",mips_pkt.ALUOut),UVM_LOW)
                `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)
            end
          6'b100101:	//or
            if((rf[mips_pkt.Instr[25:21]] | rf[mips_pkt.Instr[20:16]]) == mips_pkt.ALUOut)
            begin
                `uvm_info(get_type_name(),$sformatf("---- [OR] :: Result is as Expected :: ----"),UVM_LOW)
                `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)
            end
            else
            begin
                `uvm_error(get_type_name(),"---- [OR] :: Wrong Result :: ----")
                `uvm_info(get_type_name(),$sformatf("[OR] :: EXPECTED = %0h",(rf[mips_pkt.Instr[25:21]] | rf[mips_pkt.Instr[20:16]])),UVM_LOW)
                `uvm_info(get_type_name(),$sformatf("[OR] :: ACTUAL = %0h",mips_pkt.ALUOut),UVM_LOW)
                `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)
            end
          6'b101010:	//slt
            begin
              if(rf[mips_pkt.Instr[25:21]] < rf[mips_pkt.Instr[20:16]])
                begin
                    if(mips_pkt.ALUOut == 32'b1)
                    begin
                        `uvm_info(get_type_name(),$sformatf("---- [SLT] :: Result is as Expected :: 1 ----"),UVM_LOW)
                        `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)
                    end
                    else
                    begin
                        `uvm_error(get_type_name(),"---- [SLT] :: Wrong Result :: ----")
                        `uvm_info(get_type_name(),$sformatf("[SLT] :: EXPECTED = 32'b1"),UVM_LOW)
                        `uvm_info(get_type_name(),$sformatf("[SLT] :: ACTUAL = %0h",mips_pkt.ALUOut),UVM_LOW)
                        `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)
                    end
                end
                else
                begin
                    if(mips_pkt.ALUOut == 32'b0)
                    begin
                        `uvm_info(get_type_name(),$sformatf("---- [SLT] :: Result is as Expected :: 0 ----"),UVM_LOW)
                        `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)
                    end
                    else
                    begin
                        `uvm_error(get_type_name(),"---- [SLT] :: Wrong Result :: ----")
                        `uvm_info(get_type_name(),$sformatf("[SLT] :: EXPECTED = 32'b0"),UVM_LOW)
                        `uvm_info(get_type_name(),$sformatf("[SLT] :: ACTUAL = %0h",mips_pkt.ALUOut),UVM_LOW)
                        `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)
                    end
                end
            end
          default:
              `uvm_error(get_type_name(),"------ :: UNEXPECTED FUNCT [R-TYPE]:: ------")
          endcase
        end
            
        11: begin /* Jump */
            `uvm_info(get_type_name(),$sformatf("------ :: [J] INS = 0x%h :: ------",mips_pkt.Instr),UVM_LOW)
          if (mips_pkt.Next_PC == {mips_pkt.PC[31:26],mips_pkt.Instr[25:0]}) begin
            `uvm_info(get_type_name(),$sformatf("---- [J] :: Result is as Expected :: ----"),UVM_LOW)
            `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)
          end
          else begin
            `uvm_error(get_type_name(),"---- [J] :: Wrong Result :: ----")
            `uvm_info(get_type_name(),$sformatf("[J] :: EXPECTED = %0h",{mips_pkt.PC[31:26],mips_pkt.Instr[25:0]}),UVM_LOW)
            `uvm_info(get_type_name(),$sformatf("[J] :: ACTUAL = %0h",mips_pkt.Next_PC),UVM_LOW)
            `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)
          end
        end
        
        5:  // SW
          begin
            `uvm_info(get_type_name(),$sformatf("------ :: [SW] INS = 0x%h :: ------",mips_pkt.Instr),UVM_LOW)
//             `uvm_info(get_type_name(),$sformatf("------ :: base = %d :: ------",mips_pkt.Instr[25:21]),UVM_LOW)
//             `uvm_info(get_type_name(),$sformatf("------ :: rt = %d :: ------",mips_pkt.Instr[20:16]),UVM_LOW)
//             `uvm_info(get_type_name(),$sformatf("------ :: offset = %h :: ------",mips_pkt.Instr[15:0]),UVM_LOW)
            $readmemh("data_memory.list",ram);
            if(mips_pkt.ALUOut < 0 || mips_pkt.ALUOut > DMEMORY_WIDTH) begin
              `uvm_warning(get_type_name(),$sformatf("---- Address out of range for [SW] function ----"))
              `uvm_info(get_type_name(),"---- Function doesn't affect the memories. ----",UVM_LOW)
              `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)
            end
            else begin
              if(ram[mips_pkt.ALUOut] == mips_pkt.B) begin
                `uvm_info(get_type_name(),$sformatf("---- [SW] :: Result is as Expected :: ----"),UVM_LOW)
                `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)
                end
              else begin
                `uvm_error(get_type_name(),"---- [SW] :: Wrong Result :: ----")
                `uvm_info(get_type_name(),$sformatf("[SW] :: EXPECTED = %0h",mips_pkt.B),UVM_LOW)
                `uvm_info(get_type_name(),$sformatf("[SW] :: ACTUAL = %0h",ram[mips_pkt.ALUOut]),UVM_LOW)
                `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)
              end
            end
          end
        
        8:begin //BEQ
          `uvm_info(get_type_name(),$sformatf("------ :: [I-TYPE] INS = 0x%h :: ------", mips_pkt.Instr), UVM_LOW)
//           `uvm_info(get_type_name(),$sformatf("[BEQ] rs = %d",mips_pkt.Instr[25:21]),UVM_LOW)
//           `uvm_info(get_type_name(),$sformatf("[BEQ] rt = %d",mips_pkt.Instr[20:16]),UVM_LOW)
//           `uvm_info(get_type_name(),$sformatf("[BEQ] IMM = 0x%h",mips_pkt.Instr[15:0]),UVM_LOW)
//           `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)
          if((rf[mips_pkt.Instr[25:21]] - rf[mips_pkt.Instr[20:16]]) == 32'b0)	//branch condition
            begin
              if(mips_pkt.zero && mips_pkt.Next_PC == mips_pkt.ALUOut)
              begin
                `uvm_info(get_type_name(),$sformatf("---- [BEQ] :: Result is as Expected :: B ----"),UVM_LOW)
//                     `uvm_info(get_type_name(),$sformatf("ALUOut: %0d  Next_PC = %0d", mips_pkt.ALUOut, mips_pkt.Next_PC),UVM_LOW)
                `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)
              end
              else begin
                `uvm_error(get_type_name(),"---- [BEQ] :: Wrong Result :: ----")
                `uvm_info(get_type_name(),$sformatf("[BEQ] : EXPECTED [ZERO,ALUOut] = [1'b1,%0h]", mips_pkt.ALUOut), UVM_LOW)
                `uvm_info(get_type_name(),$sformatf("[BEQ] : ACTUAL   [ZERO,Next_PC] = [%h,%0h]", mips_pkt.zero, mips_pkt.Next_PC),UVM_LOW)
                `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)
              end
            end
          else
            begin
              if(!mips_pkt.zero) begin
                `uvm_info(get_type_name(),$sformatf("---- [BEQ] :: Result is as Expected :: NB ----"),UVM_LOW)
//                 `uvm_info(get_type_name(),$sformatf("ALUOut: %0d  Next_PC = %0d", mips_pkt.ALUOut, mips_pkt.Next_PC),UVM_LOW)
                `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)
              end
              else begin
                `uvm_error(get_type_name(),"---- [BEQ] :: Wrong Result :: NB ----")
                `uvm_info(get_type_name(),$sformatf("[BEQ] EXPECTED ZERO = 1'b0"),UVM_LOW)
                `uvm_info(get_type_name(),$sformatf("[BEQ] ACTUAL ZERO = %0h", mips_pkt.zero),UVM_LOW)
                `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)
              end
            end
        end
        
        10: /* ADDI */ begin
            `uvm_info(get_type_name(),$sformatf("------ :: [ADDI] INS = 0x%h :: ------", mips_pkt.Instr), UVM_LOW)
//             `uvm_info(get_type_name(),$sformatf("[ADDI] rs = %d",mips_pkt.Instr[25:21]),UVM_LOW)
//             `uvm_info(get_type_name(),$sformatf("[ADDI] rt = %d",mips_pkt.Instr[20:16]),UVM_LOW)
//             `uvm_info(get_type_name(),$sformatf("[ADDI] IMM = 0x%h",mips_pkt.Instr[15:0]),UVM_LOW)
            if(rf[mips_pkt.Instr[25:21]] + {{16{mips_pkt.Instr[15]}},mips_pkt.Instr[15:0]} == mips_pkt.WD3)
            begin
                if(mips_pkt.Instr[20:16] == mips_pkt.A3) begin
                  `uvm_info(get_type_name(),$sformatf("---- [ADDI] :: Result is as Expected :: ----"),UVM_LOW)
//                `uvm_info(get_type_name(),$sformatf("[ADDI] WD3 = 0x%h  A3 = %d",mips_pkt.WD3,mips_pkt.A3),UVM_LOW)
                  `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)
                end
                else
                begin
                  `uvm_error(get_type_name(),$sformatf("---- [ADDI] :: Wrong Result :: ----"))
                  `uvm_info(get_type_name(),$sformatf("[ADDI] Expected A3 = %d  Actual A3 = %d",mips_pkt.Instr[20:16],mips_pkt.A3),UVM_LOW)
                  `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)
                end
            end
            else
            begin
              `uvm_error(get_type_name(),$sformatf("---- [ADDI] :: Wrong Result :: ----"))
              `uvm_info(get_type_name(),$sformatf("[ADDI] Expected WD3 = 0x%h  Actual WD3 = 0x%h",
              rf[mips_pkt.Instr[25:21]]+{{16{mips_pkt.Instr[15]}},mips_pkt.Instr[15:0]},mips_pkt.WD3),UVM_LOW)
              `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)
            end
        end
        
        4: begin //LW
          if((rf[mips_pkt.Instr[25:21]] + {{16{mips_pkt.Instr[15]}},mips_pkt.Instr[15:0]}) < 0 ||
             (rf[mips_pkt.Instr[25:21]] + {{16{mips_pkt.Instr[15]}},mips_pkt.Instr[15:0]}) > DMEMORY_WIDTH-1)
          begin
            temp = 32'h0;
            `uvm_warning(get_type_name(),$sformatf("---- Address out of range for [LW] function ----"))
          end
          else begin
            temp = ram[rf[mips_pkt.Instr[25:21]] + {{16{mips_pkt.Instr[15]}},mips_pkt.Instr[15:0]}];
          end
          `uvm_info(get_type_name(),$sformatf("------ :: [LW] INS = %h :: ------",mips_pkt.Instr),UVM_LOW)
//           `uvm_info(get_type_name(),$sformatf("------ :: base = %h :: ------",rf[mips_pkt.Instr[25:21]]),UVM_LOW)
//           `uvm_info(get_type_name(),$sformatf("------ :: rt = %d :: ------",mips_pkt.Instr[20:16]),UVM_LOW)
//           `uvm_info(get_type_name(),$sformatf("------ :: offset = %h :: ------",mips_pkt.Instr[15:0]),UVM_LOW)
//           `uvm_info(get_type_name(),$sformatf("------ :: data = %h :: ------",temp),UVM_LOW)
          if(mips_pkt.RegWrite)
            begin
              ram[mips_pkt.A3] = mips_pkt.WD3;
              if(temp==mips_pkt.WD3)
                begin
                  `uvm_info(get_type_name(),$sformatf("---- [LW] :: Result is as Expected :: ----"),UVM_LOW)
//                   `uvm_info(get_type_name(),$sformatf("[LW] :: EXPECTED = %0h",temp),UVM_LOW)
//                   `uvm_info(get_type_name(),$sformatf("[LW] :: ACTUAL = %0h",mips_pkt.WD3),UVM_LOW)
                  `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)
                end
              else begin
                `uvm_error(get_type_name(),"---- [LW] :: Wrong Result :: ----")
                `uvm_info(get_type_name(),$sformatf("[LW] :: EXPECTED = %0h",temp),UVM_LOW)
                `uvm_info(get_type_name(),$sformatf("[LW] :: ACTUAL = %0h",mips_pkt.WD3),UVM_LOW)
                `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)
              end
            end
          else begin
            `uvm_error(get_type_name(),"---- [LW] :: Wrong Result :: ----")
            `uvm_info(get_type_name(),$sformatf("[LW] :: EXPECTED = %0h",mips_pkt.RegWrite),UVM_LOW)
            `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)
          end
        end
        //other cases
        //*************************
        //end other cases
        default:
          continue;
      endcase
        $readmemh("reg_memory.list", rf);
        $readmemh("data_memory.list",ram);//----------------------------
    end
         
    endtask : run_phase
endclass : mips_scoreboard
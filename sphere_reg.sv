typedef logic [2:0] [63:0] vector;
typedef logic [63:0] fixed_real;
typedef logic [2:0] [7:0] color;

module sphere_reg_4 (
	input logic Clk, Frame_Clk, Reset,
	input logic Hit,
	input logic [1:0] Hit_index, Read_index,
	output vector Sphere_pos,
	output color Sphere_col
);

vector [3:0] pos;
color [3:0] col;
vector [3:0] vel;
vector [3:0] acc;
vector [3:0] velacc;
vector [3:0] posvelacc;
vector [3:0] pos_n;
vector [3:0] vel_n;
color [3:0] col_n;
fixed_real random;
logic Frame_Clk_old, posedge_frame_clk;

//assign acc[0] = {64'hFFFFFFFE00000000,64'd0,64'd0};
//assign acc[1] = {64'hFFFFFFFE00000000,64'd0,64'd0};
//assign acc[2] = {64'hFFFFFFFE00000000,64'd0,64'd0};
//assign acc[3] = {64'hFFFFFFFE00000000,64'd0,64'd0};

assign acc[0] = {64'd0,64'd0,64'd0};
assign acc[1] = {64'd0,64'd0,64'd0};
assign acc[2] = {64'd0,64'd0,64'd0};
assign acc[3] = {64'd0,64'd0,64'd0};

add_vector va0(.a(vel[0]),.b(acc[0]),.c(velacc[0]));
add_vector va1(.a(vel[1]),.b(acc[1]),.c(velacc[1]));
add_vector va2(.a(vel[2]),.b(acc[2]),.c(velacc[2]));
add_vector va3(.a(vel[3]),.b(acc[3]),.c(velacc[3]));

add_vector pva0(.a(pos[0]),.b(velacc[0]),.c(posvelacc[0]));
add_vector pva1(.a(pos[1]),.b(velacc[1]),.c(posvelacc[1]));
add_vector pva2(.a(pos[2]),.b(velacc[2]),.c(posvelacc[2]));
add_vector pva3(.a(pos[3]),.b(velacc[3]),.c(posvelacc[3]));

rand_lut rl(.*);

assign posedge_frame_clk = ~Frame_Clk_old && Frame_Clk;

always_ff @ (posedge Clk or posedge Reset) begin
	if(Reset) begin
		pos[0] <= {64'b0,64'd304 << 32,64'b0};
		pos[1] <= {64'b0,64'd304 << 32,64'b0};
		pos[2] <= {64'b0,64'd304 << 32,64'b0};
		pos[3] <= {64'b0,64'd304 << 32,64'b0};
		
		vel[0] <= {64'd0,64'd0,64'd0};
		
		//vel[0] <= {16'd0,random[63:48],32'd0,{16{random[0]}},random[47:32],32'd0,{16{random[1]}},random[31:16],32'd0};
		vel[1] <= {16'd0,random[15:0],32'd0,{16{random[2]}},random[62:47],32'd0,{16{random[3]}},random[46:31],32'd0};
		vel[2] <= {16'd0,random[30:15],32'd0,{16{random[4]}},random[61:46],32'd0,{16{random[5]}},random[45:30],32'd0};
		vel[3] <= {16'd0,random[29:14],32'd0,{16{random[6]}},random[60:45],32'd0,{16{random[7]}},random[44:29],32'd0};
		
		col[0] <= {random[63:56],random[55:48],random[47:40]};
		col[1] <= {random[39:32],random[31:24],random[23:16]};
		col[2] <= {random[15:8],random[7:0],random[62:55]};
		col[3] <= {random[54:47],random[46:39],random[38:31]};
	end
	else begin
		if(posedge_frame_clk) begin
			pos <= pos_n;
			vel <= vel_n;
			col <= col_n;
		end
		else begin
			pos <= pos;
			vel <= vel;
			col <= col;
		end
		Frame_Clk_old <= Frame_Clk;
	end
end

always_ff @ (posedge Clk) begin
	Sphere_pos <= pos[Read_index];
	Sphere_col <= col[Read_index];
end

always_comb begin
	pos_n = pos;
	vel_n = velacc;
	col_n = col;
	/*
	if((pos[0][2][63]) && (~pos[0][2] + 64'b1 > (64'd1440 << 32))) begin
		pos_n[0] = {64'b0,64'd304 << 32,64'b0};
		vel_n[0] = {16'd0,random[63:48],32'd0,{16{random[0]}},random[47:32],32'd0,{16{random[1]}},random[31:16],32'd0};
		col_n[0] = {random[63:56],random[55:48],random[47:40]};
	end
	if((pos[1][2][63]) && (~pos[1][2] + 64'b1 > (64'd1440 << 32))) begin
		pos_n[1] = {64'b0,64'd304 << 32,64'b0};
		vel_n[1] = {16'd0,random[15:0],32'd0,{16{random[2]}},random[62:47],32'd0,{16{random[3]}},random[46:31],32'd0};
		col_n[1] = {random[39:32],random[31:24],random[23:16]};
	end
	if((pos[2][2][63]) && (~pos[2][2] + 64'b1 > (64'd1440 << 32))) begin
		pos_n[2] = {64'b0,64'd304 << 32,64'b0};
		vel_n[2] = {16'd0,random[30:15],32'd0,{16{random[4]}},random[61:46],32'd0,{16{random[5]}},random[45:30],32'd0};
		col_n[2] = {random[15:8],random[7:0],random[62:55]};
	end
	if((pos[3][2][63]) && (~pos[3][2] + 64'b1 > (64'd1440 << 32))) begin
		pos_n[3] = {64'b0,64'd304 << 32,64'b0};
		vel_n[3] = {16'd0,random[29:14],32'd0,{16{random[6]}},random[60:45],32'd0,{16{random[7]}},random[44:29],32'd0};
		col_n[3] = {random[54:47],random[46:39],random[38:31]};	
	end
	*/
end


endmodule


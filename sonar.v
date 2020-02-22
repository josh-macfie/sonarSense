`timescale 1ns / 1ps
// Engineer: 		MacFie
// Module Name:		Sonar.v
// Project Name:	Sonar Sensor
// Target Devices: Basys 2

module sonar( input clk,
	 output trigger,
		 input pulse,
		 output state);

reg [25:0] count;
reg n_trigger;
reg old_pulse;
reg [32:0] count_out;
reg [32:0] pulse_count;
reg [32:0] status;

initial begin
count = 25'b0;
n_trigger = 1'b0;
old_pulse = 1'b0;
count_out = 33'b0;
pulse_count = 33'b0;
status = 33'b0;
end

always @(posedge clk) begin
	count = count + 1;
	n_trigger = ~&(count[24:10]);//Pulse of 10.24us every 83ms
	if (~&(count[24:11])) begin
		if (n_trigger) begin //Trigger is active low
			if (pulse == 1) begin
				pulse_count = pulse_count + 1;
			end
			if ((old_pulse == 1)&&(pulse == 0)) begin
				count_out = pulse_count;
				pulse_count = 0;
			end
		end
	end
	if (count_out > 33'b000000000000000001110100111110000) begin
		status = status << 1;
		status[0] = 1;
	end else begin
		status = status << 1;
		status[0] = 0;
	end
	old_pulse = pulse;
end

assign trigger = n_trigger;
//Logic OR status here
assign state = |status;

endmodule

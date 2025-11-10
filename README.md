# FPGA → DDS SPI Communication

Brief: FPGA master (DE10-Lite) -> DDS (AD9834) SPI-style communication. See `doc/PROJECT2_SPI_DDS.pdf` for the report and waveforms.
# FPGA-DDS_SPI_communication
sub-projects with the aim of configuring the SPI communication between FPGA board with 40MHz Clock and DDS with 5Mhz Clock. first module handles the common clock of synchronization 5MHz , the second is for finite state machine FSM , the third combining both, the fourth putting it into application with 7 segment display.

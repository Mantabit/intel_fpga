# Intel FPGA Basic Examples

### `intel_fpga_1`

A basic examples that blink `LEDR[0]` at a frequency of approximately 10Hz.

#### `seven_seg_decoder`

Basic example which shows arithmetic processing as well as `function` usage.

## Basic integer handling

#### Typecasting

* Read out bit 20 of an `integer` : `LEDR(1) <= std_logic_vector(to_unsigned(count,23))(20);`

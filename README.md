# 1. Introduction
The full name of FPGA is Field Programmable Gate Array. It is a type of integrated circuit containing a series of programmable logic blocks and customizable interconnects that enable it to implement a wide range of digital circuits and systems. FPGAs offer flexibility and performance in digital circuit implementation compared to traditional application-specific integrated circuits (ASICs).
This project aims to complete an FPGA-based design of a stopwatch, which has the functions of a Start/Stop button, Hold button, Reset switch, and six seven-segment LED displays. The states of the two buttons and the switch are indicated by 1 for the inactive and 0 for the active states. The program is compiled on Quartus in Verilog language, and the program device is MAX 10 10M50DAF484C7G. Besides, all the modules should be paired with a testbench and validated by the testbench.
In this project, the following learning outcomes should be targeted:
1.	Understand the block diagram of a stopwatch and further learn what is the underlying logic of a stopwatch.
2.	Use the knowledge learned from the course and the engineering experience built before to complete the construction of modules in this project. 
3.	To further learn how to build testbenches to test and validate the built modules. Master the testing and debugging techniques for digital circuits and systems.

# 2. Design and Development
# 2-1. Clock Divider Module
Initially, I built the clock divider module based on the D type filp-flop. As what we have learnt in the courseware, a D type filp-flop can divide the frequency of a signal into half of its original frequency. If we loop the opposite output of each flip flop into itself, we will alternate the flip flop’s condition every second pulse of the clock. This opposite output serves as the clock for the following flip flop in the series, hence, each flip flop creates a signal at half the frequency of the one before it. Therefore, by connecting a sufficient number of D type filp-flops, we can gradually halve the frequency of the original signal. However, this is also where the problem comes from, because that the obtained signal can only be the 1/2^n of the original frequency, where n is the number of the flip-flop used. In this case, the frequency closest to the 100 Hz is the 95.37 Hz, which is obtained from (50*10^6)/2^19. Since this design is a stopwatch, the clock divider has to match exactly the frequency we need. Therefore, even though I have obtained a signal of 95.37 Hz by this way, a better method needs to be taken.
Finally, I found that there was no need to make things so complicated. To change the 50 MHz signal to 100 Hz means that the latter goes through one cycle while the former goes through 500,000 cycles. That is to say, for every 250,000 times the former changes the level, the latter changes the level once. Hence, set an integer variable to record the changing time of the 50 MHz signal. Once it equals to 250,000, reset it to be 0 and reverse the 100 Hz signal. By this logic, the function of dividing the frequency has been achieved. Then, add the reset function. Once the reset switch is toggled to 0 (active), reset the counting number and clock signal to be 0.

# 2-2. Stopwatch Logic Module
The Stopwatch Logic module is the core module of this design, which function is to convert the input 100Hz clock signal, the start/stop button signal, the reset switch signal and the hold button signal into the output minutes, seconds, centiseconds, clock indicator and overflow.
To achieve this function, there are four submodules built in this project that are called “Counter”, “GetMin”, “GetSec” and “Getdec”. Here is a diagram of this whole module, and many internal logical relationships are not discussed due to space limitations.

<img width="740" height="490" alt="image" src="https://github.com/user-attachments/assets/e2d8b497-8019-47cd-8bb5-8014983505c3" />

First, convert the input level signal to flags indicating whether to count or pause.
Secondly, take the flags, 100Hz clock signal and reset switch as the input of the counter. The counter module counts in centiseconds, and its internal logic causes it to count, stop counting, and reset based on its input. Besides, when the counter reaches 99min and 99.99s, i.e. the counting number equals to 599999, it will stop counting as well. 
Thirdly, the counting number and the 100 Hz clock signal are taken as the input of the modules of “GetMin”, “GetSec”, and “GetDec”. Each time the clock signal triggers the falling edge, these three modules convert the counting number in centiseconds to corresponding number of minutes(0-99), seconds(0-59), and centiseconds(0-99).
Simultaneously, the Clock indicator toggles each time when the counting number goes up by 50, and the Overflow changes from low to high when the counting number increases to 599999.

# 2-3. Binary to Seven Segment Encoder
The purpose of this module is to convert one six-bit binary number and two seven-bit binary numbers to 6 seven-bit binary numbers. To be more specific, these three binary numbers correspond to the number of minutes (0-99, 7 bits), seconds (0-59, 6 bits) and centiseconds (0-99, 7 bits) of the stopwatch, and the 6 seven-bit binary numbers represent the 7 display segments of each of the 6 digital tubes.
To achieve this function, the process can be divided into two steps: first convert the three binary numbers to BCD, and then transform the BCD to the binary number for the segments. Therefore, there are two submodules that need to be built first, which in my project are respectively called “EightBinaryToBCD” and “BCDToSegment”.
In Unit 4, we learned how to convert binary numbers to BCD using Boolean logic, but we only had to convert four-bit binary numbers at that time. If the binary number that needs to be converted becomes six or seven bits, using Boolean logic would become a cumbersome and completely unfeasible method. 
In this project, the binary to BCD encoder has been provided, which converts an 8-bit binary number to a 12-bit BCD. Since the inputs are either 6 or 7 bits, add one or two 0 bits ahead to match the 8-bit inputs. The method used in the given module is the double dabble algorithm, which is also called the shift-and-add-3 algorithm, and it can be implemented using a small number of gates in computer hardware, but at the expense of high latency. The algorithm is designed to efficiently convert a binary number, represented as a string of ones and zeros, into a decimal number by repeatedly shifting the binary number left and adding it to an accumulator until the decimal representation is complete.
As for the “BCDToSegment” submodule, it converts a 4-bit BCD to 7-bit binary number for the 7-segment display, and we have achieved this function in unit 4, which is also through the method of Boolean logic. For this time, I used the more straightforward “case” statement which we have also learnt in Unit 4.
Finally, this whole module has been built using these two submodules, and three “EightBinaryToBCD” modules and six “BCDToSegment” modules have been used. 

# 2-4. Stopwatch (Top-level entity)
After building the three main modules, the entire stopwatch module can be constructed by connecting in this way:

<img width="875" height="516" alt="image" src="https://github.com/user-attachments/assets/84c05b5c-5c4d-4bd9-aadf-d07feba5b302" />

My general frame is based on the given block diagram, and so there is not much difference between them. One difference is that I added the rest 8 LED outputs and set them to low as these LEDs have a certain brightness by default which is not what I expected to see.
The reset switch signal has the highest priority among all interactive functions. Once the negative edge is detected, the 100Hz signal will be set low, and the counter in Stopwatchlogic will reset to 0 and remain there while the reset is low. 
Next, the hold button signal has a higher priority than the start/stop button signal. When the timer is counting normally, the counter in the Stopwatchlogic module will stop counting when the hold button is pressed (logic 0). 
Then it comes to the start/stop button, which has the lowest priority. Each time when it is pressed (negative edge detected),  the “start” flag in the Stopwatchlogic indicating start or pause will take the inverse if the reset switch is inactive (logic 1) and the hold button is unpressed (logic 1). Next, the start flag, pause flag and reset will further determine whether the counter should count, pause or reset.
Finally, the counting number is converted to numbers of minutes, seconds and centiseconds in the StopwatchLogic module, and these numbers are the inputs of the SevenSegmentEncoder module for the segment displays.

# 3. Validation
Simulating wave plots of Stopwatch:

<img width="920" height="365" alt="image" src="https://github.com/user-attachments/assets/5db8ee56-e174-450f-b054-70fe736431ed" />

This is my final simulation result, and following steps are taken for the validation:
1.	Press start/stop button for 0.05s.
2.	Hold the pause button for 0.05s.
3.	Press start/stop button again for 0.05s.
4.	Press start/stop button once again for 0.05s.
5.	Switch the reset to be 0 (active) for 0.05s.
6.	Switch the reset to be 1 (inactive) for 0.05s.
With these operations taken, the following functions can be validated:
Start/stop button: It is initially set high (unpressed), and when the button is pressed in step 1, the counter begins counting. In the 0.1s after the button is pressed, Hex6 increases from 0 to 9 to 0, and Hex5 increases from 0 to 1 at the same time when Hex6 changes from 0 to 9, which can validate that the stopwatch is counting. In step 3, the counter should stop counting when the button is pressed again, and this can be demonstrated by the fact that Hex6 stops increasing and remains constant.
Hold button: It is initially set high (unpressed), and when it is pressed in step 2, the counter should stop counting. The fact that the Hex6 is suspended is proof of that. Then, when it is set to high (unpressed), the counter should continue to count, and the Hex6 indeed begin to increase.
Reset switch: It is initially set to high (inactive), and when it is switched to low in step 5, the counter should be reset. This can be proved by the fact that both Hex5 and Hex6 are reset to 0. In step 6 when it is switched to high again, the counter should begin to count from 0 again, and this is evidenced by the increase of Hex6 from 0.
Segment Display: The display of Hex5 and Hex6 is as expected. However, to enable the RTL simulation run smoothly, the simulation time is limited to less than 1s, so the display of Hex1-4 is not fully validated here, but in StopwatchLogic module, the number of minutes, seconds and centiseconds increase normally and automatically refresh when threshold is reached.
Since the input clock signal of the whole module is 50MHz, the simulation time is just a fraction of a second to avoid too long time response, so it is hard to see if the functions of clock indicator and overflow are correct in this testbench, and the verification of their correctness is going to be discussed in the StopwatchLogic testbench.

Simulating wave plots of StopwatchLogic:

<img width="940" height="376" alt="image" src="https://github.com/user-attachments/assets/931c18cc-4259-460e-afaf-2b01e81d21d7" />

This is the ending part of my StopwatchLogic simulation result where the counting number increases to 599999, and following functions can be validated:
Overflow: Once the counter reaches 599999, it will stop until it is reset, and the Overflow is set high as long as the counter remain at 599999. From the graph it can be seen that the Overflow is in logic 0 when the counter is less than 99min99.99s and in logic 1 when it is 99min99.99s.
Clock indicator: The clock indicator should toggle at 1 Hz when the stopwatch is counting, and it should keep where it was (either logic 1 or 0) when it is not counting. It can be seen that the clock indicator constantly switches the level when it is counting and it keeps at logic 0 while the counting is paused. 

# 4. Conclusions and Critical Reflections
**What I am most proud of: **
In this project, I have paired all the modules with a testbench and validated them with the testbench, and the time that I have spent on validation is even more than writing the modules. Writing the modules while verifying them with the testbench is a necessary thing as it can ensure that each module built operates the functions that we want. Even though it is time consuming, it can avoid the case that we get confused which module is problematic when the hardware runs the program incorrectly. Through testbench, I did find many problems in the modules, such as some variables not being initialised resulting in no output on the waveform graph, and the clock indicator keeps flickering when the counter is paused at multiples of 50. 
Besides, the writing of testbenches helped me to further understand what the functions of each module are, and what phenomena should be observed on the simulating waveform plots to validate that this module acts correctly. Finally, the program ran successfully on the board in one go because all the modules have been checked for correctness beforehand.

**The most challenging part: **
The test process of the entire module was not smooth despite that I had successfully tested the Stopwatch logic module and the program had successfully run on the hardware. 
The first difficulty I encountered is that the input clock signal of the whole module is 50MHz rather than 100Hz. The simulation workload will be enormous if we want to see the overflow of the minutes. That is to say, the simulation time must reach 99min99.99s, i.e. 599999 periods for the 100Hz signal, and this value of periods will be further multiplied by 500000 for the 50MHz clock signal. Actually, I tried to make the simulation last for a long time, but the conclusion was that it did not work because it was too slow. Therefore, the idea to validate the overflow function in the Stopwatch module was scrapped, and there are only fractions of a second in my simulation to test the functions of the buttons and the switch with a fast response. 
The second difficulty is that the output of the whole module is the binary numbers for segment displays rather than the decimal numbers that we are familiar. Certainly we can also judge the simulation results step by step by the correspondence between them, but I would prefer to have the binary numbers reconverted to decimal numbers in advance in the testbench. Again, I thought of using the case statement to do the conversion, and the following figure is an example of how I wrote it, where the Min_10 is the number of minutes we want to get in tens.

<img width="808" height="260" alt="image" src="https://github.com/user-attachments/assets/fa7cb678-aa72-4955-9c9d-d74fd30425d2" />

However, after applying this conversion to all the six binary numbers, the converted decimal numbers in the simulation result are either 0 or 8, while the  binary numbers obtained are actually correct, and I do not know what's wrong with this writing. Finally, I discarded the idea of converting binary to decimal because this step does not affect verification on the correctness of the module.

**Outlook for additional functions:**
Having completed the requested stopwatch function, I thought about the possibility of continuing to add a countdown timer functionality to this design because it is a very useful function usually combined with a stopwatch. My idea was to design a countdown timer that would allow the users to set the count down time, and it would still be able to be paused and reset during the countdown. 
More specifically, it can be implemented like this:
First, another unused switch can be used as the selection switch between the stopwatch mode and countdown timer mode. Secondly, after selecting the timer mode, the two keys are used for addition and subtraction, and three of the other unused switches can be used to select the time unit, i.e. minute, second and centisecond. After setting the time needed to be counted, there is a switch to confirm the selection. After confirmation, the two keys can be used as the start/stop button and the hold button again, and the reset switch still performs its original work.
However, this is only my vision, and it must be difficult to implement both the functions at the same time on such a development board with only two keys and ten switched. Since there are several more switches used, it would be a complicated process to determine the priorities between the different switched and buttons, and it would be necessary to consider what operation the stopwatch performs under different combinations of switches and keys. To be honest, I'm not sure how much more time I'll need to complete it, as I'm currently finding it very difficult to implement and there would be definitely more difficulties than I could have imagined if I go ahead with it.


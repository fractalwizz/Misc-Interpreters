## CompressedFck Interpreter
CompressedFck Translator written in Perl

### Disclaimer
Fractalwizz is not the author of any of the example programs.<br>
They are only provided to test the interpreter's functionality

### Module Dependencies
Getopt::Std<br>
File::Basename

### Usage
perl cbf.pl [options] textfile<br>
  -b:         Base 64 Support<br>
  textfile: path of input cbf/bf program<br>
  
ie:<br>
perl cbf.pl -b ./Examples/cat.cbf

### Features
Translates instructions between BrainFck and CompressedFck<br>
Supports Base 64 Encoding/Decoding

### License
MIT License<br>
(c) 2016 Fractalwizz<br>
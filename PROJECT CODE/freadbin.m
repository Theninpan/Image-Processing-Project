function out = freadbin(fname,varargin)
% FREADBIN  Read formatted data from a binary file.
%
% FREADBIN(FILENAME,'PropertyName1',value1,'PropertyName2',value2,...)
%   necessary property names:
%     FILENAME is a string containing the name of the file to be opened.
%     'SAMPLEFORMAT' is a cell array of strings which describes the sample
%           format of the binary data.
%
%     Examples:
%           {'ID:1*int16=>double' 'LABEL:8*char' 'ignore:4*int8' 'DATA:20*int8'}
%
%           * this means that each sample in the binary file is 34 bytes long
%               - [1*int16] + [8*char] + [4*int8] + [20*int8] = 34 bytes
%           * each sample contains a 
%               - 'ID' which is stored in the first 2 bytes as INT16,
%               - 'LABEL' which has a length of 8 chararacters
%               - next 4 bytes should be ignored using the "IGNORE"-keyword
%               - 'DATA' with a total length of 20 bytes.
%           * '=>' should be used to specify the destination format of data
%                 (See also FREAD)
%     
%   optional property names:
%     'OFFSET' Offset in bytes from the beginning of the file.
%     'RANGE'  Range of samples to read. Can be specified as a scalar or
%              a vector. All data will be read, if not specified. 
%     'MACHINEFORMAT' specify the local machine format (See also FREAD)
%     'OUTPUTFORMAT' is one of the following strings
%           'struct'      the output data stored as a struct - the default (faster)
%           'structarray' as an array of structs (slower)
%              
%
% Example:
% 
% The following tutorial shows the steps to read a WAV-Fie.
% The WAVE file format is a subset of Microsoft's RIFF specification.
%
% 1.Step - We need a detailed description of the file format.
% ===========================================================
% file format specification of WAV-File
% link a) [http://ccrma.stanford.edu/courses/422/projects/WaveFormat]
% link b) [http://technology.niagarac.on.ca/courses/ctec1631/WavFileFormat.html]
%
% A WAV-file starts out with a file header followed by a sequence of data
% chunks. 
%
% WAV-File Header
%
% RIFF Chunk (12 Bytes in length total)
% Offset      Name           Size  Description
% --------------------------------------------
%   0 - 3     ChunkID        4     "RIFF" (ASCII Characters)
%   4 - 7     ChunkSize      4     Total Length Of Package To Follow
%   8 - 11    Format         4     "WAVE" (ASCII Characters)
%
% FORMAT Chunk (24 bytes in length total)
% Offset      Name           Size  Description
% --------------------------------------------
%  12 - 15    Subchunk1ID    4     "fmt_" (ASCII Characters)
%  16 - 19    Subchunk1Size  4     Length Of FORMAT Chunk (always 0x10)
%  20 - 21    Audioformat    2     Always 0x01
%  22 - 23    NumChannels    2     Channel Numbers (0x01=Mono, 0x02=Stereo)
%  24 - 27    SampleRate     4     Sample Rate (in Hz)
%  28 - 31    ByteRate       4     Bytes Per Second
%  32 - 33    BlockAlign     2     Bytes Per Sample: 1=8 bit Mono, 2=8
%                                  bit Stereo or 16 bit Mono, 4=16 bit Stereo
%  34 - 35    BitsPerSample  2     Bits Per Sample
%
% DATA Chunk
% Offset      Name           Size  Description
% --------------------------------------------
%  36 - 39    Subchunk2ID    4     "data" (ASCII Characters)
%  40 - 43    Subchunk2Size  4     Length Of Data To Follow
%  44 - end   Data (Samples) xxx   sound data
%
%
% 2.Step - Get the header information.
% ====================================
%   * first argument is the name of the binary file.
%   * WAV files contain only one header at the start of the binary file, 
%     so we should use 1 as 'range'.
%   * outputformat is struct.
%   * the most important part is the specification of the 'sampleformat'.
%     To understand it just compare the used cell array with the WAV-file
%     header specification. It is very comprehensible!
%
% >> header = freadbin( ...
%    'sndStartup.wav', ...
%    'range',1, ...
%    'outputformat','struct', ...
%    'sampleformat',{
%       'ChunkID:4*char' ...
%       'ChunkSize:1*int32=>double' ...
%       'Format:4*char' ...
%       'Subchunk1ID:4*char' ...
%       'Subchunk1Size:4*int8' ...
%       'AudioFormat:2*int8' ...
%       'NumChannels:1*int16=>double' ...
%       'SampleRate:1*int32=>double' ...
%       'ByteRate:1*int32=>double' ...
%       'BlockAlign:1*int16=>double' ...
%       'BitsPerSample:1*int16=>double' ...
%       'Subchunk2ID:4*char' ...
%       'Subchunk2Size:1*int32=>double'})
%
% header output for the example WAV-file 'sndStartup.wav':
% 
% >> header = 
% 
%           ChunkID: 'RIFF'
%         ChunkSize: 86054
%            Format: 'WAVE'
%       Subchunk1ID: 'fmt '
%     Subchunk1Size: [16 0 0 0]
%       AudioFormat: [1 0]
%       NumChannels: 2
%        SampleRate: 22050
%          ByteRate: 44100
%        BlockAlign: 2
%     BitsPerSample: 8
%       Subchunk2ID: 'data'
%     Subchunk2Size: 86018
%
%
% 3.Step - Get the data.
% ======================
%   * The WAV file header has a size of 44 Bytes and we use this value as
%     'offset' to place the pointer at the start of the data chunk.
%   * we use 'struct' as 'outputformat'.
%   * based on the header information we know that the WAV file has 2
%     channels (NumChannels) per Sample and 1 Byte per Sample (BitsPerSample)
%     per Channel. This means, that the 'sampleformat' should look like 
%     {'channel1:1*uint8' 'channel2:1*uint8'}
% 
% data = freadbin( ...
%    'sndStartup.wav', ...
%    'offset',44, ...
%    'outputformat','struct', ...
%    'sampleformat',{'channel1:1*uint8' 'channel2:1*uint8'})
%
% data output:
% 
% >> data = 
% 
%     channel1: [43009x1 uint8]
%     channel2: [43009x1 uint8]
%
% Test the data using WAVPLAY function
% (don't forget to switch on the speaker! :)
%
% >> wavplay([data.channel1 data.channel2],header.SampleRate)
%
%
%   Version: v1.0
%      Date: 2009/12/16 00:00:00
%   (c) 2009 By Elmar Tarajan [MCommander@gmx.de]

% Initializing
snum = inf;
offset = 0;
sstart = 1;
send = inf;
out = struct;
machineformat = 'native';
outputformat = 1;
%
% Parse Inputs
for n = 1:2:length(varargin)
   switch lower(varargin{n})
      case 'offset'
         offset = varargin{n+1};
         %
      case 'range'
         sstart = min(varargin{n+1});
         send = max(varargin{n+1})-sstart+1;
         %
      case 'sampleformat'
         fformat = varargin{n+1};
         %
      case 'machineformat'
         machineformat = varargin{n+1};
         %
      case 'outputformat'
         switch varargin{n+1}
            case 'structarray' , outputformat = 1; % slower
            case 'struct'      , outputformat = 0; % faster
         end% switch
   end
end% for
%
% open file
fid = fopen(fname,'r',machineformat);
%
% Prepare File Format
tmp = regexp(fformat,'\w*','match');
names = cellfun(@(x) x{1},tmp,'UniformOutput',0);
prec = cellfun(@(x) eval(x{2}),tmp);
%
precision = {'uchar' 'schar' 'int8' 'int16' 'int32' 'int64' ...
             'uint8' 'uint16' 'uint32' 'uint64' 'single' ...
             'float32' 'double' 'float64' 'char' 'short' ...
             'int' 'long' 'ushort' 'uint' 'ulong' 'float'};
%
bytelength = [1 1 1 2 4 8 1 2 4 8 4 4 8 8 1 2 4 4 2 4 4 4];
bytelength = cellfun(@(x) bytelength(strcmp(x{3},precision)),tmp);
precXlength = prec.*bytelength;
%
% read out the data
fseek(fid,offset+(sstart-1)*sum(bytelength.*prec),-1);
for n = 1:length(fformat)
   if ~strcmpi('ignore',names{n})
      %
      if length(tmp{n})<4
         tmp{n}{4} = tmp{n}{3};
      end% if
      data = fread(fid,[prec(n) send], ...
         sprintf('%s*%s=>%s',tmp{n}{2},tmp{n}{3},tmp{n}{4}), ...
         sum(precXlength)-precXlength(n));
      %
      if outputformat
         % structarray
         data = mat2cell(data',ones(1,size(data,2)),prec(n))   ;
         [out(1:size(data,2)).(names{n})] = data;
      else
         % struct
         [out.(names{n})] = data';
         %
      end% if
      %
   end
   fseek(fid,offset+(sstart-1)*sum(prec)+sum(precXlength(1:n)),-1);
end% for
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% I LOVE MATLAB! You too? :) %%%
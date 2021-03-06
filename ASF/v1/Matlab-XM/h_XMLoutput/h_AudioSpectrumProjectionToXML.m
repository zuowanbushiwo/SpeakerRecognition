function fileName=AudioProjectionBasisToXML(P,vargs)
% AudioSpectrumProjectionToXML(AudioSpectrumProjectionD,[Optional Args]); 
%    - generates an XML file for AudioSpectrumProjectionD
%
% AudioSpectrumProjectionD values is a t x (1 + k) matrix with
% t=number of time points
% k=number of basis functions used for the projection (+1 for L2-norm env)
%
% The following variables are optional, and are specified using
% ['parameter', value pairs] on the command line.
%   
%    'hopSize'            'PT10N1000F'  - AudioSpectrumEnvelopeD hopSize
%    'loEdge'              62.5,        - AudioSpectrumEnvelopeD low Hz
%    'hiEdge'              16000,       - AudioSpectrumEnvelopeD high Hz
%    'octaveResolution'    '1/8'        - AudioSpectrumEnvelopeD resolution
%    'outputFile'           ''          - Filename for Model output [stem+mp7.xml]


% Author: Michael A. Casey
% Language: Matlab
% Based on ISO/IEC FDIS 15938-4
%
% Version 2.0 
% created 12/08/2003

Mpeg7_wrapper='Mpeg7_wrapper.xml';

if ~isempty(vargs.outputFile)
        fileName=vargs.outputFile;
end       

%--------------------------
%determines the number of sample vectors 
%and the number of frequency bands
[totalNumOfSamples vectorSize]=size(P);

%--------------------------
%creation of the xml file:
try
    xmlFile=fopen(vargs.outputFile,'w');  %opens the file in write mode
catch
    error(lasterr);
end    

%-------------------------
%XML generation:

%Mpeg7 wrapper:
try
    mpeg7File=fopen(Mpeg7_wrapper,'r');  %opens the file containing the Mpeg7 wrapper
catch
    error(lasterr);
end    

%copies the wrapper in the new XML file:
while ~feof(mpeg7File)
    line=fgets(mpeg7File);
    fprintf(xmlFile,'%s',line);
end    
fclose(mpeg7File);

%				<AudioDescriptor xsi:type="AudioSpectrumProjectionType">
%					<SeriesOfVector hopSize="PT500N1000F" totalNumOfSamples="30" vectorSize="6">
%						<Raw mpeg7:dim="6 50 30">

%Descriptor generation:
line='<Description xsi:type="ContentEntityType">';
fprintf(xmlFile,'\t%s\n',line);
line='<MultimediaContent xsi:type="AudioType">';
fprintf(xmlFile,'\t\t%s\n',line);
line='<Audio xsi:type="AudioSegmentType">';
fprintf(xmlFile,'\t\t\t%s\n',line);
line='<MediaTime>';
fprintf(xmlFile,'\t\t\t\t%s\n',line);
line='<MediaTimePoint>T00:00:00</MediaTimePoint>';
fprintf(xmlFile,'\t\t\t\t\t%s\n',line);
line='<MediaDuration>PT31S675N1000F</MediaDuration>';
fprintf(xmlFile,'\t\t\t\t\t%s\n',line);
line='</MediaTime>';
fprintf(xmlFile,'\t\t\t\t%s\n',line);

line=['<AudioDescriptor xsi:type="AudioSpectrumProjectionType">'];
fprintf(xmlFile,'\t%s\n',line);
%<SeriesOfVector hopSize="PT500N1000F" totalNumOfSamples="30" vectorSize="5">
%						<Raw mpeg7:dim="5 10 30">

line=['<SeriesOfVector totalNumOfSamples="1">'];
fprintf(xmlFile,'\t\t%s\n',line);

line=['<Raw mpeg7:dim="' num2str(totalNumOfSamples) ' ' num2str(vectorSize) '">'];
fprintf(xmlFile,'\t\t\t%s\n',line);	

%AudioSpectrumProjectionD raw values:
for i=1:totalNumOfSamples
    fprintf(xmlFile,'\t\t\t\t');
    fprintf(xmlFile,'%10.5f ',P(i,:));
    fprintf(xmlFile,'\n');
end    

line='</Raw>';
fprintf(xmlFile,'\t\t\t%s\n',line);

line='</SeriesOfVector>';
fprintf(xmlFile,'\t\t%s\n',line);

line='</AudioDescriptor>';
fprintf(xmlFile,'\t%s\n',line);

line='</Audio>';
fprintf(xmlFile,'\t%s\n',line);

line='</MultimediaContent>';
fprintf(xmlFile,'\t%s\n',line);

line='</Description>';
fprintf(xmlFile,'\t%s\n',line);

%Mpeg7 end tag:
line='</Mpeg7>';
fprintf(xmlFile,'%s\n',line);

fclose(xmlFile);


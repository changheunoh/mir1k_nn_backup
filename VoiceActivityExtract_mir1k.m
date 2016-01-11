function VAresult = VoiceActivityExtract_mir1k(path_label)


myCommand = ['myLoading = load(''', path_label,''');'];
eval(myCommand);


pitchData = myLoading(:,2);
VAresult = ( pitchData ~=0);



end
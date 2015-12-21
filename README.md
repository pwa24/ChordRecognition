# ChordRecognition
CMPT 419 Machine Learning Project

###Description
Automatic music chord recognition using Hidden Markov Model Perceptron Model. The algorithm takes in a MIDI input re-encoded as a list of events, then learns the corresponding chord labels for those events.

[[more]](paper/nips2015.pdf)

###Running:
`Choose parameters in setup.m`
```
>>setup
>>perceptron_skel
>>validate(X,T,W,[<indicies of X to test on>])
```

###Results:
79% accuracy when trained and tested on JS Bach Chorales Dataset.

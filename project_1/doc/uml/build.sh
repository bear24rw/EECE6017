# use case diagram
dot -Tpng use_case.dot > use_case.png

# sequence diagram
pic2plot -Tsvg uml.seq > seq.svg
rsvg-convert -o seq.png seq.svg
convert -trim seq.png seq_2.png

# state diagram
dot -Tpng -Kcirco states.dot > states.png

pdflatex uml.tex

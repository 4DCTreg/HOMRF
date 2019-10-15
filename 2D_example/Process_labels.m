function labels=Process_labels(labels_search)
labels.sx=labels_search(1);
labels.sy=labels_search(2);

labels.nlabels=labels.sx*labels.sy;
labels.hy=floor(labels.sy/2);
labels.hx=floor(labels.sx/2);


end
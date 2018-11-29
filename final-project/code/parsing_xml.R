
library(XML)
?readHTMLTable

doc <- xmlParse('rawdata/sabasin.xml',
              useInternalNodes = TRUE)
class(doc)

is.list(doc)
length(doc)

root <- xmlRoot(doc)

child <- xmlChildren(root)
length(child)

# header (not very useful)
length(child[[1]])
child[[1]]

# first disturbance (storm)
length(child[[2]])

xmlName(child[[2]])
xmlAttrs(child[[2]])
xmlGetAttr(child[[2]], name = 'type')
# disturbance
xmlChildren(child[[2]])


xmlSize(root)
root[[4]]
xmlSApply(root, xmlName)


lapply(y, xmlName)
lapply(y[[1]], xmlAttrs)
xmlValue(y[[1]])

nodes <- getNodeSet(root, "//data")
length(nodes)



class(nodes)  # list
length(nodes)

lapply(nodes, function(x) xmlSApply(x, xmlValue))
class(y[[1]])


xpathApply(root, "//cycloneName", xmlValue)
xpathApply(root, "//data", xmlValue)
xpathApply(root, "//fix", xmlValue)

xpathApply(root, "//disturbance", xmlName)
dist_attrs <- xpathApply(root, "//disturbance", xmlAttrs)
dist_attrs[[1]]

xpathApply(
  root, 
  sprintf('//disturbance[@ID="%s"]//fix', dist_attrs[[1]]),
  xmlValue
)



xmlSApply(root[[3]], xmlValue)
xmlSApply(root[[3]][[1]], xmlValue)
xmlSApply(root[[3]][[1]], xmlChildren)
xmlSApply(root[[3]][[1]][[2]], xmlValue)


set.seed(10)
m = matrix(rnorm(15), 5, 3)
A = cbind(m, m[,1], rep(1,5))
apply(A, 2, var)
any(as.numeric(cor(A) - diag(diag(cor(A)))) == 1.0)
any(as.numeric(cor(A) - diag(diag(cor(A)))) == 1.0)



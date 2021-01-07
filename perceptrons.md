# Table of Contents

1.  [Rosenblatt&rsquo;s perceptron](#org2c2b523)
    1.  [Introduction](#org6fc9e4c)
    2.  [Perceptron convergence theorem](#orgba984a8)

<a id="org2c2b523"></a>

# Rosenblatt&rsquo;s perceptron

<a id="org6fc9e4c"></a>

## Introduction

_Recall_: for an input \(x\in\mathop{\mathbb{R}}^n\), the parametrized function describing the mapping computed by a perceptron is:
\[
F(\omega,x)=F((\omega*1,\omega_2,\ldots,\omega_n,\theta),(x_1,x_2,\ldots,x_n))=sgn(\sum*{i=1}^n \omega_i x_i - \theta)
\]
Or in the vector form:
\[
F(\bv{\omega}, \bv{x}) = sgn(\bv{\omega^Tx})
\]
This perceptron can only classify patterns which are _linearly seprable_.
There is a theorem, that given perceptron is able to understand in a finite number of _learning updates_ \(k\) which class \(C_1\) or \(C_2\) an input from training example \(\bv{z_t}=(\bv{x_t},y_t)\) (where \(t\) is a training step and number of the training sample) belongs to.

<a id="orgba984a8"></a>

## Perceptron convergence theorem

From definition above we can conclude that training example \(x\) belongs to class \(C_1\) if \(sgn(\cdot)>0\) and to class \(C_2\) if \(sgn(\cdot)\leq 0\). Suppose we have training set \(X\), where \(x\in X\) and \(x(t)\) is a \(t\text{-th}\) element of \(X\). Let&rsquo;s note \(\omega(t)\) as a state of the perceptron at training iteration \(t\). In case of misclassifications a learning rule can be applied:
\[
\omega(t + 1) =\omega(t) - \eta x(t)\ \text{if}\ sgn(\cdot)\leq 0
\]
\[
\omega(t + 1) =\omega(t) + \eta x(t)\ \text{if}\ sgn(\cdot) > 0
\]
where \(\eta\) - _learning rate_ parameter.

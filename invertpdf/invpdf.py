#!/usr/bin/python

'''
 Note : The key function used is cumsum which can be easily substituted
        if numpy is not installed
'''

import numpy as np
from bisect import bisect_right
from random import random

import unittest

class RandomGen:
    def __init__(self,rv, pdf_bins):

        fp_tol = .001;
        if len(rv)!= len(pdf_bins):
            raise ValueError('random variable and pdf arrays must be of same size')

        # cdf would be always non-decreasing
        if np.any(np.array(pdf_bins)<0) :
            raise ValueError('probabilities must be non-negative')

        self._random_nums = rv
        self._probabilities = pdf_bins

        self.cdf= np.concatenate((np.array([0]),np.cumsum(pdf_bins)),0)

        if abs(self.cdf[-1] -1)>fp_tol:
            raise ValueError('pdf:\"'+str(pdf_bins)+'\" must add up to unity')


    def nextNum(self):
        # find rightmost value less than the sample random variable
        value = random()
        index = bisect_right(self.cdf,value) # random () must be between 0 and 1
        # constraints on cdf ensure that index is always valid
        return self._random_nums[index-1]


class RandomGenUnitTests(unittest.TestCase):

    def test_negative_pdf(self):
        pdf_input = [0,-1,2]
        with self.assertRaises(ValueError):
           pdfgen = RandomGen(rv=[0,1,2],pdf_bins=pdf_input)

    def test_pdf_size(self):
        pdf_input = [0,-1]
        with self.assertRaises(ValueError):
           pdfgen = RandomGen(rv=[0,1,2],pdf_bins=pdf_input)

    def test_zero_probability(self):
        pdf_input = [0,0.02,0,0,0,.98]
        rv_input = [0,1,2,3,4,5]
        pdfgen = RandomGen(rv=rv_input,pdf_bins=pdf_input)
        samples=[]
        for i in range(0,10000):
            samples.append(pdfgen.nextNum())

        self.assertEqual(rv_input[0] in samples,False)
        self.assertEqual(rv_input[2] in samples,False)
        self.assertEqual(rv_input[3] in samples,False)
        self.assertEqual(rv_input[4] in samples,False)

    def test_convergence(self):
        pdf_input = [0.01,0.3,.58,.1,.01]
        rv_input = [-1,0,1,2,3]
        fptol = .01;
        nsamples = 100000
        pdfgen = RandomGen(rv=rv_input,pdf_bins=pdf_input)
        samples = []
        for i in range(0,nsamples):
            samples.append(pdfgen.nextNum())
        (hist,bin_edges)=np.histogram(a=samples,bins=5);
        print "pdf",pdf_input
        print "hist=",hist/float(sum(hist))
        compare_array = (np.array(hist/float(sum(hist)))-np.array(pdf_input))
        self.assertEqual(any(abs(compare_array)>fptol),False)

if __name__ == '__main__':
    unittest.main()

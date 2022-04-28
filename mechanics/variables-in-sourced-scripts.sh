#!/bin/bash


case ${VARIABLE} in
	set)
		echo matched variable in script being sourced
		function abc() {
			echo abc
		}
	;;
	*)
		false
	;;
esac


#!/usr/bin/env node

/**
 * Wraps @param fun in a try-catch block and ignores the error. Useful for e.g. ignoring output from $`cp`
 */
export async function safe(fun = () => {}) {
    try {
        await fun();
    }
    catch (error) {
        //ignore
    }
};

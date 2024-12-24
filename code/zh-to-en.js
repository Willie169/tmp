let args = process.argv.slice(2);
args.forEach((arg, index) => {
    let pattern = /\\item (\S+)（([^（）\n]+)）(.*) /;
    if (pattern.test(arg)) {
        console.log(arg.replace(pattern, '\\item $2 ($1)$3'));
    } else {
        console.log("Pattern not matched.");
    }
});

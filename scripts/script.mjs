#!/usr/bin/env zx

// install Java if necessary
if (process.env.SKIP_JAVA == 'false' && !(await $`java --version`).stdout.match(process.env.JAVA_VERSION)) {
    $`./install-java.sh`;
}
else {
    console.log('Matching Java version detected, skipping');
}

await fs.writeFile('eula.txt', process.env.EULA);

// copy all flat data to workdir
$`cp $DATA_DIR $WORK_DIR`

if (process.env.FORCE_DOWNLOAD == 'true') {
    console.log('########### deleting $JAR_NAME ###############')
    $`rm $JAR_NAME`;
}

switch (process.env.TYPE) {
    case "custom":
        //custom
        break;
    case 'fabric':
        //fabric
        break;
}
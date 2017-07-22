const gulp = require('gulp');
const zip = require('gulp-zip');

gulp.task('build', () =>
	gulp
		.src('lambda/ses-lambda/ses-lambda.js')
		.pipe(zip('ses-lambda.zip'))
		.pipe(gulp.dest('./dist/'))
);

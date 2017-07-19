const gulp = require('gulp');
const zip = require('gulp-zip');

gulp.task('build', () =>
	gulp
		.src('ses-lambda.js')
		.pipe(zip('ses-lambda.zip'))
		.pipe(gulp.dest('./../../dist/'))
);

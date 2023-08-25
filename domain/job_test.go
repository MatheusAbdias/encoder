package domain_test

import (
	"testing"
	"time"

	"github.com/MatheusAbdias/encoder/domain"
	uuid "github.com/satori/go.uuid"
	"github.com/stretchr/testify/require"
)

func TestNewJob(t *testing.T) {
	video := domain.NewVideo()
	video.ID = uuid.NewV4().String()
	video.Path = "Path"
	video.CreatedAt = time.Now()

	job, err := domain.NewJob("Path", "Converted", video)
	require.NotNil(t, job)
	require.Nil(t, err)
}
